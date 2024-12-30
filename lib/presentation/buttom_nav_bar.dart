import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_travel_app/presentation/home.dart';
import 'package:flutter_travel_app/presentation/notify.dart';

import 'booking.dart';
import 'profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late List<Widget> pages;
  late Home home;
  late Booking booking;
  late Notify notif;
  late Profile profile;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    home = Home();
    booking = Booking();
    notif = Notify();
    profile = Profile();
    pages = [home, booking, notif, profile];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.white,
        buttonBackgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 300),
        items: [
          buildNavItem(Icons.home_outlined, 0),
          buildNavItem(Icons.book_online, 1),
          buildNavItem(Icons.notifications, 2),
          buildNavItem(Icons.person, 3),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: pages[currentIndex],
    );
  }

  Widget buildNavItem(IconData icon, int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: currentIndex == index
            ? LinearGradient(
                colors: [Color(0xFFFB4A4A), Color(0xFF2027CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: currentIndex == index ? Colors.white : Color(0xffB1BBBF),
        size: 30,
      ),
    );
  }
}
