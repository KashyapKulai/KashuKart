import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_project/screens/item_screen.dart';
//import 'package:practice_project/models/testing_list.dart';
//import 'package:practice_project/screens/item_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    /*void refreshScreen() {
      setState(() {
      // This will trigger a rebuild and reflect any changes to the `items`.
      });
    }*/
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('items').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: const Text('No data Present'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemScreen(
                          id: snapshot.data!.docs[index].data()['id'],
                          title: snapshot.data!.docs[index].data()['item'],
                          price: snapshot.data!.docs[index].data()['price'],
                          quantity: snapshot.data!.docs[index].data()['quantity'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Text(snapshot.data!.docs[index].data()['item']),
                  ),
                );
              },
            );
          }),
    );
  }
}
