import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_project/screens/item_screen.dart';
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
        stream:FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).where('type',isEqualTo:'cart' ).snapshots() ,
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          if (snapshot.data!.docs.isEmpty) {
                return Center(child: const Text('Cart is empty'));
          }
          return ListView.builder(
            itemCount:snapshot.data!.docs.length ,
            itemBuilder:(context,index){
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemScreen(
                          id: snapshot.data!.docs[index].data()['id'],
                          title: snapshot.data!.docs[index].data()['title'],
                          price: snapshot.data!.docs[index].data()['price'],
                          quantity: snapshot.data!.docs[index].data()['quantity'],
                        ),
                      ),
                    );
                },
                child: Container(
                  padding: const EdgeInsets.all(0.8),
                  child: Column(
                    children: [
                      Text(snapshot.data!.docs[index].data()['title']),
                      Text(snapshot.data!.docs[index].data()['price'].toString()),
                      Text(snapshot.data!.docs[index].data()['quantity'].toString()),
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