import 'package:flutter/material.dart';
import '/ui/widgets/custom_button_red.dart';
import '/shared/theme.dart';

class ProfileMenuPage extends StatefulWidget {
  const ProfileMenuPage({super.key});

  @override
  State<ProfileMenuPage> createState() => _ProfileMenuPageState();
}

class _ProfileMenuPageState extends State<ProfileMenuPage> {
  // boolean for dark mode
  bool _isSwitched = false;

  // To change the selected value of bottom navigation bar
  int _selectedIndex = 4;  
  void _changeSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      switch(index){
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        // case 2:
        //   Navigator.pushNamed(context, '/order');
        //   break;
        // case 3:
        //   Navigator.pushNamed(context, '/notification');
        //   break;
        // case 4:
        //   Navigator.pushNamed(context, '/profilemenu');
        //   break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1,
        toolbarHeight: 100, //CHECK
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_circle_left_rounded,
            color: primaryColor,
            size: 55,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            color: Colors.white,
            child: Column(children: [
              Text('Profile Menu',
                  style: greenTextStyle.copyWith(
                    fontSize: 40,
                    fontWeight: bold,
                  )),
            ]),
          ),
        ),
      ),
      body: Container(
        color: kUnavailableColor,
        child: ListView(
          children: [
            // profile detail
            const SizedBox(height: 15),

            // profile card
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: backgroundColor,
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      CircleAvatar(
                        backgroundImage: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/loh-coffee-eatery.appspot.com/o/profilepics%2F460A2392-7E42-4C79-8E5D-C5035CD243D5.jpg?alt=media&token=3bde7f21-462b-4824-bf64-ae6c7761bbb1')
                        .image,
                        backgroundColor: kUnavailableColor,
                        radius: 30, //size
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Renaldhi Fahrezi',
                            style: mainTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: bold,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          Text(
                            'renaldhifahrezi48@gmail.com',
                            style: mainTextStyle.copyWith(
                              fontSize: 15,
                              fontWeight: bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      //* TODO: Navigate to profile detail page
                      // Navigator.pushNamed(context, '/profile');
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Account Setting title
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 10),
              child: Text(
                'Account Settings',
                style: greenTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // Account Setting Content

            // Edit Preferences
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              height: 50,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: backgroundColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.fastfood_rounded,
                        color: primaryColor,
                        size: 26,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Edit Menu Preferences",
                        style: greenTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  IconButton(
                    // * TODO: Navigate to edit preferences page
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Submit Review
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              height: 50,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: backgroundColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.rate_review_rounded,
                        size: 26,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Submit Review",
                        style: greenTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  IconButton(
                    // * TODO: Navigate to submit review page
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // General Setting title
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 10),
              child: Text(
                'General Settings',
                style: greenTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // General Setting Content

            // Dark Mode
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              height: 50,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: backgroundColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.dark_mode_rounded,
                        size: 26,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Dark Mode",
                        style: greenTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Switch(
                    // * TODO: Iteration 3: Implement Dark Mode
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                  value: _isSwitched,
                  activeColor: primaryColor,
                  ),
                ],
              ),
            ),

            // Switch Language
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              height: 50,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: backgroundColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.translate_rounded,
                        size: 26,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Switch Language to Indonesia",
                        style: greenTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Switch(
                    // * TODO: Iteration 3: Implement Switch Language
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                  value: _isSwitched,
                  activeColor: primaryColor,
                  ),
                ],
              ),
            ),

            // How to Use Loh App
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              height: 50,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: backgroundColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.help_rounded,
                        size: 26,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "How to Use Loh App",
                        style: greenTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  IconButton(
                    // * TODO: Navigate to How to Use Loh App page
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonRed(
                title: 'Sign Out', 
                onPressed: (){}
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Reserve',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted_rounded),
            label: 'Order List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: greyColor,
        showUnselectedLabels: true,
        onTap: _changeSelectedIndex
      ),
    );
  }
}
