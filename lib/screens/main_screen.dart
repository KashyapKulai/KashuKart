import 'package:flutter/material.dart';
import 'package:practice_project/models/item.dart';
import 'package:practice_project/models/testing_list.dart';
import 'package:practice_project/screens/item_screen.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  

  @override
  Widget build(BuildContext context) {

    void refreshScreen() {
      setState(() {
      // This will trigger a rebuild and reflect any changes to the `items`.
      });
    }

    return Scaffold(
      body:  ListView.builder(
        itemCount: items.length,
        itemBuilder:(context,index){
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemScreen(item: items[index]),
                ),
              ).then((_) {
                // Refresh the screen after returning from ItemScreen
                refreshScreen();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(0.8),
              child: Column(
                children: [
                  Text(items[index].title),
                  Text(items[index].amount.toString()),
                  Text(items[index].quantity.toString()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}