import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:practice_project/models/cart_item.dart';
//import 'package:practice_project/screens/item_screen.dart';
class CartScreen extends StatefulWidget{
 const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    print(FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).snapshots().toString());
    return Scaffold(
      body:StreamBuilder(
        stream:FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).snapshots() ,
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
                print('loading cart');
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                print('empty');
                return Center(child: const Text('Cart is empty'));
          }
          return ListView.builder(
            itemCount:snapshot.data!.docs.length ,
            itemBuilder:(context,index){
              return GestureDetector(
                onTap: () {
                  
                },
                child: Container(
                  padding: const EdgeInsets.all(0.8),
                  child: Column(
                    children: [
                      Text(snapshot.data!.docs[index].data()['title']),
                      Text(snapshot.data!.docs[index].data()['price']),
                      Text(snapshot.data!.docs[index].data()['quantity']),
                    ],
                  ),
                ),
              );
            },
          );
        }
      )
    );
  }
}