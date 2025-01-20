import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:practice_project/models/item.dart';
//import 'package:practice_project/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: must_be_immutable
class ItemScreen extends StatefulWidget{
  const ItemScreen({super.key,required this.id,required this.title,required this.price,required this.quantity});
  final String id;
  final String title;
  final String price;
  final String quantity;
  @override
  State<StatefulWidget> createState() {
    return _ItemSCreenState();
  }
}

class _ItemSCreenState extends State<ItemScreen>{
  int cartCount = 0;

  /*void quantityR(){
    setState(() {
      
    });
  }*/
  Future<void> addToCart(int quantity)async{
    try{
      final data = await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).add({
        'id':widget.id,
        'price':widget.price,
        'quantity':quantity.toString(),
        'title':widget.title,
        'typee':'cart',
      });
    }on FirebaseException catch(e){
      print(e);
    }
  }

  Future<void> updateQuantity(int quantity)async{
    CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot querySnapshot = await collection.where('id', isEqualTo: widget.id).get();
    String documentId = querySnapshot.docs.first.id;
    DocumentReference documentRef = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(documentId);
    await documentRef.update({'quantity': quantity.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('kashukart'),
      ),
      body: Column(
        children: [
          Text(widget.title),
          Text(widget.price),
          ElevatedButton(onPressed: ()async{
            cartCount+=1;
            if(cartCount==1){
              await addToCart(cartCount);
            }
            else if(cartCount<=int.parse(widget.quantity)){
              await updateQuantity(cartCount);
            }
            else{
              AlertDialog(
                title: Text('Maximum Amount reached'),
              );
            }
            }, 
            child:const Text('add to cart'),
          ),
          ElevatedButton(
            onPressed: (){
              
            },
            child:const Text('Buy now')),
        ],
      ),
    );
  }
}