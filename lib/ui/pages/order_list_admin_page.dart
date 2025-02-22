import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:intl/intl.dart';
import 'package:loh_coffee_eatery/cubit/order_cubit.dart';
import 'package:loh_coffee_eatery/cubit/payment_state.dart';
import 'package:loh_coffee_eatery/models/payment_model.dart';
import 'package:loh_coffee_eatery/models/review_model.dart';
import 'package:loh_coffee_eatery/ui/pages/order_details_page.dart';
import 'package:loh_coffee_eatery/ui/widgets/custom_button.dart';
import 'package:loh_coffee_eatery/ui/widgets/custom_button_white.dart';
import '../../cubit/review_cubit.dart';
import '../../models/menu_model.dart';
import '../../shared/theme.dart';
import '../widgets/custom_button_red.dart';
import '../../cubit/payment_cubit.dart';

class OrderListAdminPage extends StatefulWidget {
  const OrderListAdminPage({super.key});

  @override
  State<OrderListAdminPage> createState() => _OrderListAdminPageState();
}

class _OrderListAdminPageState extends State<OrderListAdminPage> {
  @override
  void initState() {
    context.read<OrderCubit>().getOrders();
    super.initState();
  }

  String orderStatus = 'Pending';
  String diningOption = 'Dine In';
  String paymentStatus = 'Confirmed';
  bool isOpen = false;
  bool isConfirm = false;

  final CollectionReference<Map<String, dynamic>> orderList =
      FirebaseFirestore.instance.collection('orders');

  final CollectionReference<Map<String, dynamic>> paymentList =
      FirebaseFirestore.instance.collection('payments');

  final CollectionReference<Map<String, dynamic>> menuList =
      FirebaseFirestore.instance.collection('menus');

  final CollectionReference<Map<String, dynamic>> userList =
      FirebaseFirestore.instance.collection('users');

  //method to change orderList to descending order
  Future<void> changeOrderListToDescending() async {
    await orderList.orderBy('number', descending: true).get();
  }

  //get order length
  Future<int> orderLength() async {
    AggregateQuerySnapshot query = await orderList.count().get();
    print('The number of order: ${query.count}');
    return query.count;
  }

  //get order number by index
  Future<int> getOrderNumberByIndex(int index) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await orderList
        .orderBy('number', descending: true)
        .limit(index + 1)
        .get();
    int orderNumber = querySnapshot.docs[index].data()['number'];
    return orderNumber;
  }

  //get order id by order number
  Future<String> getOrderIdByOrderNumber(int orderNumber) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await orderList.where('number', isEqualTo: orderNumber).get();
    if (querySnapshot.docs.isNotEmpty) {
      String id = querySnapshot.docs.first.id;
      return id;
    } else {
      throw Exception("No order found with order number $orderNumber");
    }
  }

  //get order timestamp by order number
  Future<Timestamp> getOrderTimestampByOrderNumber(int orderNumber) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await orderList.where('number', isEqualTo: orderNumber).get();
    if (querySnapshot.docs.isNotEmpty) {
      Timestamp timestamp = querySnapshot.docs.first.data()['orderDateTime'];
      return timestamp;
    } else {
      throw Exception("No order found with order number $orderNumber");
    }
  }

  //get payment by timestamp in payment cubit
  Future<PaymentModel> getPaymentByTimestamp(Timestamp timestamp) async {
    PaymentModel payment = await context
        .read<PaymentCubit>()
        .getPaymentByTimestamp(paymentDateTime: timestamp);

    return payment;
  }

  Future<String> formatTime(PaymentModel payment) async {
    Timestamp time = payment.paymentDateTime;
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
    String formattedTime = dateFormat.format(dateTime);

    return formattedTime;
  }

  //get customer name by order number
  Future<String> getCustomerNameByOrderNumber(int orderNumber) async {
    String orderId = await getOrderIdByOrderNumber(orderNumber);
    Timestamp timestamp = await getOrderTimestampByOrderNumber(orderNumber);
    PaymentModel payment = await getPaymentByTimestamp(timestamp);
    String customerName = payment.customerName;
    print('Customer Name ini: $customerName');
    print('Order ID: $orderId');
    return customerName;
  }

  //get table number by order number
  Future<int> getTableNumberByOrderNumber(int orderNumber) async {
    String orderId = await getOrderIdByOrderNumber(orderNumber);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await orderList.doc(orderId).get();
    int tableNumber = documentSnapshot.data()!['tableNum'];
    print('Table Number: $tableNumber');
    return tableNumber;
  }

  //get order status by order number
  Future<String> getOrderStatusByOrderNumber(int orderNumber) async {
    String orderId = await getOrderIdByOrderNumber(orderNumber);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await orderList.doc(orderId).get();
    String orderStatus = documentSnapshot.data()!['orderStatus'];
    print('Order Status: $orderStatus');
    return orderStatus;
  }

  //get list of menu id by order number
  Future<List<String>> getMenuIdByOrderNumber(int orderNumber) async {
    String orderId = await getOrderIdByOrderNumber(orderNumber);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await orderList.doc(orderId).get();
    List<dynamic> menuListHere = documentSnapshot.data()!['menu'];
    List<String> menuIdList = [];

    for (int i = 0; i < menuListHere.length; i++) {
      String menuTitle = menuListHere[i]['title'];

      //get menuModel by comparing menuTitle with menuList
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await menuList.where('title', isEqualTo: menuTitle).get();
      if (querySnapshot.docs.isNotEmpty) {
        String menuId = querySnapshot.docs.first.id;
        menuIdList.add(menuId);
      } else {
        throw Exception("No menu found with title $menuTitle");
      }
    }
    print('Menu ID List: $menuIdList');
    return menuIdList;
  }

  //get list of MenuModel by order number
  Future<List<MenuModel>> getMenuByOrderNumber(int orderNumber) async {
    List<String> menuIdList = await getMenuIdByOrderNumber(orderNumber);
    List<MenuModel> menuModelList = [];

    for (int i = 0; i < menuIdList.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await menuList.doc(menuIdList[i]).get();
      Map<String, dynamic> data = documentSnapshot.data()!;
      MenuModel menuModel = MenuModel(
        id: documentSnapshot.id,
        title: data['title'],
        description: data['description'],
        tag: data['tag'],
        price: data['price'],
        image: data['image'],
        totalLoved: data['totalLoved'],
        totalOrdered: data['totalOrdered'],
        userId: List<String>.from(data['userId']),
        quantity: data['quantity'],
      );
      menuModelList.add(menuModel);
    }
    print('Menu Model List: $menuModelList');
    return menuModelList;
  }

  //get user id by order number
  Future<String> getUserIdByOrderNumber(int orderNumber) async {
    String orderId = await getOrderIdByOrderNumber(orderNumber);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await orderList.doc(orderId).get();
    String userEmail = documentSnapshot.data()!['user']['email'];

    //get user document by comparing userName with userList
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await userList.where('email', isEqualTo: userEmail).get();
    if (querySnapshot.docs.isNotEmpty) {
      String userId = querySnapshot.docs.first.id;
      print('User ID: $userId');
      return userId;
    } else {
      throw Exception("No user found with name $userEmail");
    }
  }

  //method to get orders by lopping through orderList length and call orderHeader
  Widget getOrders() {
    return FutureBuilder<int>(
      future: orderLength(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //call paymentHeader without using ListView.builder
          return Column(
            children: [
              for (int i = 0; i < snapshot.data!; i++)
                FutureBuilder<Widget>(
                  future: orderHeader(i),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          width: 0.8 * MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Center(
                              child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              snapshot.data!,
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        )
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
            ],
          );
        } else {
          //return no payments
          return Center(
            child: Text('no_order'.tr()),
          );
        }
      },
    );
  }

  Future<Widget> orderHeader(int index) async {
    int orderNumber = await getOrderNumberByIndex(index);
    Timestamp orderTime = await getOrderTimestampByOrderNumber(orderNumber);
    PaymentModel payment = await getPaymentByTimestamp(orderTime);
    String time = await formatTime(payment);

    String orderStatus = await getOrderStatusByOrderNumber(orderNumber);
    if (orderStatus == 'Pending') {
      isConfirm = false;
    } else {
      isConfirm = true;
    }

    // String customerName = await getCustomerNameByOrderNumber(orderNumber + 1);
    return GestureDetector(
      onTap: () async {
        // String name = await getCustomerNameByIndex(orderNumber);
        // print('Customer Name: $name');
        // getCustomerNameByOrderNumber(orderNumber + 1);
        // getTableNumberByOrderNumber(orderNumber + 1);
        // getOrderStatusByOrderNumber(orderNumber + 1);
        // getMenuIdByOrderNumber(orderNumber + 1);
        // getMenuByOrderNumber(orderNumber + 1);
        // getUserIdByOrderNumber(orderNumber + 1);

        setState(() {
          // Navigator.pushNamed(context, '/order-details');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderDetailsPage(orderNumber: orderNumber)));
        });
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'nav_orders'.tr() + ' No: ${orderNumber}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: greenTextStyle.copyWith(
                fontSize: 14,
                fontWeight: black,
              ),
            ),

            const SizedBox(height: 5),

            //* Order Date
            Text(
              'order_date'.tr() + ' : ${time}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: mainTextStyle.copyWith(
                fontSize: 14,
                fontWeight: black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // spacer line
        const SizedBox(height: 5),
        Container(
          width: 0.8 * MediaQuery.of(context).size.width,
          height: 5,
          color: kUnavailableColor,
        ),

        const SizedBox(height: 10),
        //* Customer Name
        Text(
          'customer_name'.tr() + ' \${Customer Name}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: greenTextStyle.copyWith(
            fontSize: 16,
            fontWeight: medium,
          ),
        ),
        const SizedBox(height: 10),
        // spacer line
        const SizedBox(height: 5),
        Container(
          width: 0.8 * MediaQuery.of(context).size.width,
          height: 5,
          color: kUnavailableColor,
        ),
        const SizedBox(height: 10),

        //* Order Details
        Text(
          'Dining Option: \${Dine In/Takeaway}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: greenTextStyle.copyWith(
            fontSize: 16,
            fontWeight: medium,
          ),
        ),
        const SizedBox(height: 10),
        //* Table Number
        Visibility(
          visible: diningOption == 'Dine In' ? true : false,
          child: Text(
            'Table Number: \${1}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: greenTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
        ),
        const SizedBox(height: 5),

        // spacer line
        const SizedBox(height: 5),
        Container(
          width: 0.8 * MediaQuery.of(context).size.width,
          height: 5,
          color: kUnavailableColor,
        ),
        //* Order Content
        orderContent(),
        // spacer line
        Container(
          width: 0.8 * MediaQuery.of(context).size.width,
          height: 5,
          color: kUnavailableColor,
        ),

        //* TOTAL PRICE
        const SizedBox(height: 10),
        Text(
          'Total Price:',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: greenTextStyle.copyWith(
            fontSize: 16,
            fontWeight: black,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              'Rp',
              style: orangeTextStyle.copyWith(
                fontSize: 16,
                fontWeight: extraBold,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              // iPrice.toString(),
              '69420',
              style: orangeTextStyle.copyWith(
                fontSize: 16,
                fontWeight: extraBold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // spacer line
        const SizedBox(height: 5),
        Container(
          width: 0.8 * MediaQuery.of(context).size.width,
          height: 5,
          color: kUnavailableColor,
        ),
        const SizedBox(height: 10),

        //* Payment Status
        Text(
          'Payment Status:',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: greenTextStyle.copyWith(
            fontSize: 16,
            fontWeight: black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          paymentStatus,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: greenTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
          ),
        ),
        const SizedBox(height: 10),

        //* order Status
        Text(
          'Order Status:',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: greenTextStyle.copyWith(
            fontSize: 16,
            fontWeight: black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          orderStatus,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: orderStatus == 'Confirmed'
              ? greenTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                )
              : orangeTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
        ),
        const SizedBox(height: 10),
        // spacer line
        const SizedBox(height: 5),
        Container(
          width: 0.8 * MediaQuery.of(context).size.width,
          height: 5,
          color: kUnavailableColor,
        ),

        const SizedBox(height: 15),
        //* Confirm order button
        Visibility(
          visible: !isConfirm && paymentStatus == 'Confirmed',
          child: CustomButton(
              title: 'Confirm order',
              onPressed: () {
                setState(() {
                  // print('confirm button');
                  // print('isConfirm then: ${isConfirm}');
                  // print('pay status then: ${orderStatus}');
                  isConfirm = true;
                  orderStatus = 'Confirmed';
                  // print('isConfirm now: ${isConfirm}');
                  // print('pay status now: ${orderStatus}');
                });
              }),
        ),
        const SizedBox(height: 15),

        //* Reject order button
        Visibility(
          visible: !isConfirm && paymentStatus == 'Confirmed',
          child: CustomButtonRed(
            title: 'Reject order',
            onPressed: () {
              setState(() {
                // print('reject button');
                // print('isConfirm then: ${isConfirm}');
                // print('pay status then: ${orderStatus}');
                isConfirm = true;
                orderStatus = 'Rejected';
                // print('isConfirm now: ${isConfirm}');
                // print('pay status now: ${orderStatus}');
              });
            },
          ),
        ),
        // order status
        const SizedBox(height: 15),
      ],
    );
  }

  Widget orderContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        //* Order Name
        Text(
          'Makanan 1',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: greenTextStyle.copyWith(
            fontSize: 16,
            fontWeight: black,
          ),
        ),
        const SizedBox(height: 5),

        Text(
          'Qty: 1',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: greenTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (paymentStatus == 'Confirmed' && !isConfirm) {
      orderStatus = 'Pending';
    } else if (paymentStatus == 'Confirmed' && isConfirm) {
      if (orderStatus == 'Confirmed') {
        orderStatus = 'Confirmed';
      } else if (orderStatus == 'Rejected') {
        orderStatus = 'Rejected';
      }
    } else if (paymentStatus == 'Rejected') {
      orderStatus = 'Rejected';
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          width: double.infinity,
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_circle_left_rounded,
                        color: primaryColor,
                        size: 55,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            'customer_order_list'.tr(),
                            style: greenTextStyle.copyWith(
                              fontSize: 26,
                              fontWeight: bold,
                            ),
                          ),
                        ),

                        //* REFRESH BUTTON
                        AnimatedIconButton(
                          size: 26,
                          onPressed: () {
                            setState(() {});
                          },
                          duration: const Duration(seconds: 1),
                          splashColor: Colors.transparent,
                          icons: <AnimatedIconItem>[
                            AnimatedIconItem(
                              icon: Icon(Icons.refresh, color: primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ), // Header End

              //* Order Header
              getOrders(),
            ],
          ),
        ),
      ),
    );
  }
}
