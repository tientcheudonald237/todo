import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

import 'category/categorie.dart';
import 'tache/home.dart';
import 'profil/profil.dart';
import 'projet/Projet.dart';

const _kPages = <String, Widget>{
  'search': FormPage(),
  ' ': Categorie(),
  'profil': ProfilPage(),
};

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  _HomePages createState() => _HomePages();
}

class _HomePages extends State<HomePages> {
  int _currentPage = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          FormPage(),
          Categorie(),
          Projet(),
          ProfilPage(),
        ],
        onPageChanged: (index) {
          // Use a better state management solution
          // setState is used for simplicity
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: const <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.task_alt),
            title: Text('Tache'),
            activeColor: Colors.blue,
          ),
          BottomBarItem(
            icon: Icon(Icons.category),
            title: Text('Description'),
            activeColor: Colors.red,
          ),
          BottomBarItem(
            icon: Icon(Icons.light),
            title: Text('Projet'),
            activeColor: Colors.green,
          ),
          BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('User'),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
