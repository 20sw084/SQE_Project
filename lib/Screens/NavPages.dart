import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import '/Components/Palette.dart';
import '/Screens/AddMedsPage.dart';
import '/Screens/CalenderPage.dart';
import '/Screens/HomePage.dart';
import '/Screens/LandingPage.dart';
import '/Screens/LoginPage.dart';
import '/Screens/MedsOnClickPage.dart';
import '/Screens/PeriodPage.dart';
import '/Screens/PeriodTrackerPage.dart';
import '/Screens/ProfilePage.dart';

import '/Screens/RegisterPage.dart';
import '/Screens/SettingPage.dart';
import '/Screens/FinalLogPage.dart';
import '/Screens/EmailVerifyPage.dart';

class NavPages extends StatefulWidget {
  const NavPages({Key? key}) : super(key: key);

  @override
  State<NavPages> createState() => _NavPagesState();
}

class _NavPagesState extends State<NavPages> {
  // List of pages to be displayed in the Bottom Nav Bar
  List<Widget> pages = [
    HomePage(), // Index 0
    CalendarPage(), // Index 1
    PeriodTracker(), // Index 2
    SettingScreen(), // Index 3
  ];

  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      extendBody: true,
        floatingActionButton: Opacity(
        opacity: keyboardIsOpened ? 0 : 1,
        child: FloatingActionButton(
        enableFeedback:true,
        onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  AddMedsPage()),
      );
    },
    child: Icon(Icons.add),
    backgroundColor: Pallete.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF000000), // Start color
                  const Color(0xFF333333), // Middle color
                  const Color(0xFF666666), // End color
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: BottomNavigationBar(
              elevation: 10,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Pallete.primary,
              unselectedItemColor: Colors.black26,
              type: BottomNavigationBarType.fixed,
              items: [
                // Bottom Nav Items, icons, and styles
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Image.asset(
                    'assets/icons/appss.png',
                    width: 30,
                    height: 30,
                  ),
                  activeIcon: Image.asset(
                    'assets/icons/appss.png',
                    width: 30,
                    height: 30,
                    color: Pallete.primary,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Calendar",
                  icon: Image.asset(
                    'assets/images/calendarLogo.png',
                    width: 30,
                    height: 30,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/calendarLogo.png',
                    width: 30,
                    height: 30,
                    color: Pallete.primary,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Cycle",
                  icon: Image.asset(
                    'assets/images/4th.png',
                    width: 24,
                    height: 24,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/4th.png',
                    width: 24,
                    height: 24,
                    color: Pallete.primary,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Profile",
                  icon: Icon(Icons.person_2_rounded),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),

          );
        },
      ),
      body: pages[_selectedIndex],
    );
  }
}
