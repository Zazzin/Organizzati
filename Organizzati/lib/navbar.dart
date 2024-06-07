import 'package:app/calendar_home.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'inventary.dart';
import 'people_invenory.dart';
import 'settings_controller.dart';


class NavBar extends StatefulWidget {
  final SettingsController settingsController;


  NavBar({Key? key, required this.settingsController}) : super(key: key);


  @override
  _NavBarState createState() => _NavBarState();
}


class _NavBarState extends State<NavBar> {
  late PageController _pageController;
  int _selectedPage = 0;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedPage);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(widget.settingsController.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              setState(() {
                widget.settingsController.updateThemeMode(
                  widget.settingsController.themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark,
                );
              });
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
        children: [
          const CalendarHomePage(),
          const InventoryScreen(),
           PeopleInventory(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.transparent,
            color: const Color.fromARGB(255, 0, 74, 74),
            activeColor: const Color.fromARGB(255, 35, 219, 133),
            tabBackgroundColor: Colors.black12,
            gap: 8,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
              ),
              GButton(
                icon: Icons.inventory_2_outlined,
                text: 'Storage',
              ),
              GButton(
                icon: Icons.person_add_alt_1_outlined,
                text: 'Staff',
              ),
              // GButton(
              //   icon: Icons.settings_suggest_outlined,
              //   text: 'Settings',
              // ),
            ],
            selectedIndex: _selectedPage,
            onTabChange: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.ease,
              );
            },
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}


