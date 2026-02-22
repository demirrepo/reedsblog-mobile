import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Center(
      child: Text(
        "Management (Posts List goes here)",
        style: TextStyle(color: Colors.white),
      ),
    ),
    const Center(
      child: Text(
        "Reads (Public Feed goes here)",
        style: TextStyle(color: Colors.white),
      ),
    ),
    const Center(
      child: Text(
        "Profile (About Me goes here)",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  final List<String> _titles = ["Manage Posts", "Reeds", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0d1a2b),
      appBar: AppBar(
        backgroundColor: Color(0xff0d1a2b),
        elevation: 0,
        title: Text(
          _titles[_currentIndex],
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF1E293B),
        selectedItemColor: Color(0xFF166534),
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Icon(Icons.edit_document),
            ),
            label: "Manage",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Icon(Icons.library_books_rounded),
            ),
            label: "Reeds",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Icon(Icons.person),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
