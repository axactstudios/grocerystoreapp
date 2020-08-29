import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerystoreapp/Classes/Constants.dart';
import 'package:grocerystoreapp/Screens/NavBarScreens/CompletedOrders.dart';
import 'package:grocerystoreapp/Screens/NavBarScreens/More.dart';
import 'package:grocerystoreapp/Screens/NavBarScreens/NewOrders.dart';
import 'package:grocerystoreapp/Screens/NavBarScreens/Products.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [Products(), NewOrders(), CompletedOrders(), More()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.tags_solid),
        title: ("Products"),
        activeColor: kAccentColor,
        inactiveColor: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.fiber_new),
        title: ("New Orders"),
        activeColor: kAccentColor,
        inactiveColor: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.check_mark_circled_solid),
        title: ("Completed Orders"),
        activeColor: kAccentColor,
        inactiveColor: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("More"),
        activeColor: kAccentColor,
        inactiveColor: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: kSecondaryColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
