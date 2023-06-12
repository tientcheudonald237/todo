import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'add/Categorie.dart';
import 'home/home.dart';
import 'profil/profil.dart';

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
  final TabStyle _tabStyle = TabStyle.reactCircle;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  for (final icon in _kPages.values) icon,
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          style: _tabStyle,
          backgroundColor: Colors.black,
          items: const <TabItem>[
            TabItem(icon: Icon(Icons.home), title: 'Home'),
            TabItem(icon: Icon(Icons.add), title: ' '),
            TabItem(icon: Icon(Icons.account_circle_rounded), title: 'profil'),
          ],
          color: Colors.black,
          activeColor: Colors.grey,
          onTap: (int i) => print('click index=$i'),
        ),
      ),
    );
  }
}
