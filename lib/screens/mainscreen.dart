import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

  int _page = 0;

  List pages = [
    {
      'title': 'Home',
      'icon': Ionicons.home,
      'page': Feeds(),
      'index': 0,
    },
    {
      'title': 'Search',
      'icon': Ionicons.search,
      'page': Search(),
      'index': 1,
    },
    {
      'title': 'unsee',
      'icon': Ionicons.add_circle,
      'page': Text('nes'),
      'index': 2,
    },
    {
      'title': 'Notification',
      'icon': CupertinoIcons.bell_solid,
      'page': Activities(),
      'index': 3,
    },
    {
      'title': 'Profile',
      'icon': CupertinoIcons.person_fill,
      'page': Profile(profileId: firebaseAuth.currentUser!.uid),
      'index': 4,
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageTransitionSwitcher(
        transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
    ){
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
          child: pages[_page]['page'],
        ),
    );
  }
}
