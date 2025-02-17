import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:practice_project/screens/cart.dart';
import 'package:practice_project/screens/item_add_screen.dart';
import 'package:practice_project/screens/main_screen.dart';
import 'package:practice_project/screens/profile_detail.dart';

class Tabscreen extends StatefulWidget{
  const Tabscreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TabscreenState();
    
  }
}

class _TabscreenState extends State<Tabscreen>{
  int _selectedPageIndex = 0;
  void _selectPage(int index){
    setState(() {
      _selectedPageIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home,),
      Icon(Icons.shopping_cart,),
      Icon(Icons.person,),
    ];

    final screens = [
      MainScreen(),
      CartScreen(),
      ProfileDetail(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('KashuKart'),
        leading: IconButton(
          onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddItemScreen(),
              ),
            );
          }
         , icon:const Icon(Icons.add)),
      ),
      body: screens[_selectedPageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        color: Colors.blue,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.white,
        onTap: _selectPage,
        index: _selectedPageIndex,
        items: items
      ),
    );
  }
}