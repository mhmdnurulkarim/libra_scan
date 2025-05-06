import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libra_scan/presentation/screens/home/home_user_screen.dart';
import 'package:libra_scan/presentation/screens/profile/profile_screen.dart';
import 'package:libra_scan/presentation/screens/search/search_admin_screen.dart';
import 'package:libra_scan/presentation/screens/search/search_user_screen.dart';

import 'home/home_admin_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String? role;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final user_id = FirebaseAuth.instance.currentUser?.uid;
    if (user_id == null) return;

    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(user_id)
              .get();

      final roleRef = userDoc.data()?['role'] as DocumentReference?;
      if (roleRef != null) {
        final roleDoc = await roleRef.get();
        final roleData = roleDoc.data() as Map<String, dynamic>?;
        final roleName = roleData?['name'] as String?;
        setState(() {
          role = roleName ?? 'user';
        });
      } else {
        setState(() {
          role = 'user';
        });
      }
    } catch (e) {
      print("Error fetching role: $e");
      setState(() {
        role = 'user';
      });
    }
  }

  List<Widget> get _children {
    return [
      role == 'admin' ? HomeAdminScreen() : HomeUserScreen(),
      role == 'admin' ? SearchAdminScreen() : SearchUserScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
