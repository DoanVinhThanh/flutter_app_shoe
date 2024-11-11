import 'package:flutter/material.dart';
import 'package:flutter_/screens/user/home_screen.dart';
import 'package:flutter_/screens/user/order_screen.dart';
import 'package:flutter_/screens/user/profile_screen.dart';


import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  final String userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final List<Widget> _pages = [
       HomeScreen(userEmail: widget.userEmail),
       OrderScreen(userEmail: widget.userEmail),
      // const FavoriteScreen(),
      ProfileScreen(userEmail: widget.userEmail), 
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.white,
            gap: 8,
            tabBorderRadius: 30,
            tabBackgroundGradient: LinearGradient(colors: [
              Colors.blue.shade400,
              Colors.blue.shade300,
              Colors.blue.shade200,
            ]),
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Trang chủ',
                iconColor: Colors.blue,
                textColor: Colors.white,
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: Icons.local_shipping,
                text: 'Đơn hàng',
                iconColor: Colors.blue,
                textColor: Colors.white,
                iconActiveColor: Colors.white,
              ),
              // GButton(
              //   icon: Icons.favorite_border,
              //   text: 'Yêu thích',
              //   iconColor: Colors.blue,
              //   textColor: Colors.white,
              //   iconActiveColor: Colors.white,
              // ),
              GButton(
                icon: Icons.person,
                text: 'Tài khoản',
                iconColor: Colors.blue,
                textColor: Colors.white,
                iconActiveColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
