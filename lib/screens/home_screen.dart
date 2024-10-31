import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'followers_tab.dart';
import 'post_tab.dart';
import 'profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    const FollowersTab(),
    const PostTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black, // Background color for Home tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Followers',
            backgroundColor: Colors.black, // Background color for Followers tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Post',
            backgroundColor: Colors.black, // Background color for Post tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.black, // Background color for Profile tab
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // Highlight color for selected item
        unselectedItemColor: Colors.grey[600], // Color for unselected items
        onTap: _onItemTapped,
        type: BottomNavigationBarType.shifting, // To allow different tab background colors
      ),
    );
  }
}
