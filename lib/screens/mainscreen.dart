import 'package:flutter/material.dart';
import 'package:connectify/screens/Home_fragment.dart';
import 'package:connectify/screens/Followers_fragment.dart';
import 'package:connectify/screens/Post_fragment.dart';
import 'package:connectify/screens/Profile_fragment.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _fragments = [
    HomeFragment(),
    FollowersFragment(),
    PostFragment(),
    ProfileFragment(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _fragments[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Followers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Change this to blue
        unselectedItemColor: Colors.grey, // Optional: Change this for unselected items
        showUnselectedLabels: true,
      ),
    );
  }

}
