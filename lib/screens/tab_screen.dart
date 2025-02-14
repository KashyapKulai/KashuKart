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
    Widget activePage =  MainScreen();
    if(_selectedPageIndex==1){
      activePage = const CartScreen();
    }
    if(_selectedPageIndex==2){
      activePage = const ProfileDetail();
    }
    return Scaffold(
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
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
           BottomNavigationBarItem(icon:  Icon(Icons.home) ,label:'Home' ),
           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label:'Cart' ),
           BottomNavigationBarItem(icon: Icon(Icons.person),label:'Profile' ),
        ],
      ),
    );
  }
}