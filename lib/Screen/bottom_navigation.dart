import 'package:article/Screen/home.dart';
import 'package:article/Screen/kategori.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarExampleApp extends StatelessWidget {
  final String username;
  final String topik;
  final String jk;
  final String email;

  BottomNavigationBarExampleApp(
      {required this.username,
      required this.topik,
      required this.jk,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBarExample(
        username: username,
        topik: topik,
        jk: jk,
        email: email,
      ),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  final String username;
  final String topik;
  final String jk;
  final String email;

  const BottomNavigationBarExample(
      {required this.username,
      required this.topik,
      required this.jk,
      required this.email,
      Key? key})
      : super(key: key);

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      Home(
          username: widget.username,
          topik: widget.topik,
          jk: widget.jk,
          email: widget.email), // Pass the username here
      KategoriBeritaCNN(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
            backgroundColor: Colors.pinkAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategori',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
