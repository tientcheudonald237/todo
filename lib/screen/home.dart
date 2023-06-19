import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'category/categorie.dart';
import 'tache/home.dart';
import 'profil/profil.dart';
import 'projet/Projet.dart';
import './authentification/signIn.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  _HomePages createState() => _HomePages();
}

class _HomePages extends State<HomePages> {
  int _currentPage = 0;
  final _pageController = PageController();
  double _xPosition = 0;
  double _yPosition = 0;
  double _dx = 0;
  double _dy = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
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
          Positioned(
            left: _xPosition + _dx,
            top: _yPosition + _dy,
            child: GestureDetector(
              onPanStart: (details) {
                _dx = _xPosition - details.globalPosition.dx;
                _dy = _yPosition - details.globalPosition.dy;
              },
              onPanUpdate: (details) {
                setState(() {
                  _xPosition = details.globalPosition.dx + _dx;
                  _yPosition = details.globalPosition.dy + _dy;
                });
              },
              onLongPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
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
            title: Text('Category'),
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
