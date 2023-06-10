import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'acceuil.dart';

import 'creancierScreen.dart';
import 'operations.dart';

class Home extends StatefulWidget {
  final String username;

  Home({required this.username});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _username;
  int _page = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    screens = [
      Acceuil(username: _username),
      Operations(username: _username),
      CreancierScreen(username: _username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black45,
            activeColor: Colors.white,
            tabBackgroundColor: Color(0xFF146C94),
            gap: 10,
              padding: EdgeInsets.all(16),
              tabs: [
            GButton(
              icon: Icons.home,
              text: "Acceuil",
            ),
            GButton(
              icon: Icons.history,
              text: "Operations",
            ),
            GButton(
              icon: Icons.receipt_rounded,
              text: "Factures",
            ),
          ],
            selectedIndex: _page,
            onTabChange: (index){
              setState(() {
                _page = index;
              });
            },
          ),
        ),
      ),
      body: IndexedStack(
        index: _page,
        children: screens,
      ),
    );
  }
}
