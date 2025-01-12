import 'package:flutter/material.dart';
import 'package:practice_project/models/testing_list.dart';
import 'package:practice_project/screens/item_screen.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView.builder(
        itemCount: items.length,
        itemBuilder:(context,index){
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ItemScreen(item: items[index],)));
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