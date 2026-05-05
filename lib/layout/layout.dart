import 'package:calculations/features/slips/presentation/pages/slips.dart';
import 'package:calculations/features/employees/presentation/pages/employees.dart';
import 'package:calculations/features/products/presentation/pages/products.dart';
import 'package:calculations/features/settings/presentation/pages/setting.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Layout extends StatefulWidget {
  const Layout({
    super.key,
  });

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _currentIndex = 0;
  List<Widget> pages = [
    Slips(),
    Employees(),
    Products(),
    Setting(),
  ];
  List<String> pageTitles = [
    "Calculations",
    "Peoples",
    "Products",
    "Settings",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        title: Text(
          pageTitles[_currentIndex].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8),
        child: pages[_currentIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF5B58FF),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidFileLines),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userGroup),
            label: "Peoples",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.box),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.gear),
            label: "Settings",
          ),
        ],
        currentIndex: _currentIndex,
      ),
    );
  }
}
