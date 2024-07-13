import 'package:flutter/material.dart';
import 'package:teach_app/views/home.dart';
import 'package:teach_app/views/learn_yourself.dart';
import 'package:teach_app/views/learning.dart';
import 'package:teach_app/views/profile.dart';

class Routers extends StatefulWidget {
  const Routers({super.key});

  @override
  State<Routers> createState() => _RoutersState();
}

class _RoutersState extends State<Routers> {
  final List<BottomNavigationBarItem> _items = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
    const BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: "Öğren"),
    const BottomNavigationBarItem(icon: Icon(Icons.draw_outlined), label: "Çiz"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
  ];
  int _currentPageIndex = 0;
  late final List<Widget> _pages;
  @override
  void initState() {
    _pages = [
      HomePage(
        changedPageIndex: (index) => setState(() {
          _currentPageIndex = index;
        }),
      ),
      const LearningPage(),
      const LearnYourself(),
      const ProfilePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentPageIndex,
          onTap: (value) {
            setState(() {
              _currentPageIndex = value;
            });
          },
          items: _items),
    );
  }
}
