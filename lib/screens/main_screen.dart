import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      body:  StreamBuilder<Object>(
        stream: FirebaseFirestore.instance.collection('item').snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(!snapshot.hasData){
            return const Text('No data here ');
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder:(context,index){
              return GestureDetector(
                onTap: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemScreen(item: items[index]),
                    ),
                  ).then((_) {
                    // Refresh the screen after returning from ItemScreen
                    refreshScreen();
                  });*/
                },
                child: Container(
                  padding: const EdgeInsets.all(0.8),
                  child: Column(
                    children: [
                      Text(snapshot.data!.docs[index].data()['itemName'].toString()),
                      Text(snapshot.data!.docs[index].data()['price'].toString()),
                      Text(snapshot.data!.docs[index].data()['quantity'].toString()),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}