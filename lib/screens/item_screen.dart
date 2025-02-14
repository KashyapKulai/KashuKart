import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: must_be_immutable
class ItemScreen extends StatefulWidget{
  const ItemScreen({super.key,required this.id,required this.title,required this.price,required this.quantity});
  final String id;
  final String title;
  final int price;
  final int quantity;
  @override
  State<StatefulWidget> createState() {
    return _ItemSCreenState();
  }
}

class _ItemSCreenState extends State<ItemScreen>{
  int quantityCounter = 0;
  bool isLoading=true;

  Future<int> quantityCal() async{
    int quantityCart=0;
    CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot querySnapshot = await collection.where('id', isEqualTo: widget.id).get();
    if (querySnapshot.docs.isNotEmpty ) {
        String documentId = querySnapshot.docs.first.id;
        DocumentReference documentRef = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(documentId);
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(documentId)
        .get();
        quantityCart = documentSnapshot.get('quantity');
    }
    return quantityCart;
  }

  void initState() {
    super.initState();
    _callAsyncFunction();
  }

  Future<void> _callAsyncFunction() async {
    int data = await quantityCal(); 
    setState(() {
      quantityCounter = data;
      isLoading=false;
    });
  }
  
  void refreshScreen(){
    setState(() {
    });
  }
  
  Future<void> updateQuantity()async{
    CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot querySnapshot = await collection.where('id', isEqualTo: widget.id).get();
    if (querySnapshot.docs.isNotEmpty ) {
      print('not empty');
        String documentId = querySnapshot.docs.first.id;
        DocumentReference documentRef = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(documentId);
        int quantityCart =await quantityCal();
        quantityCounter = quantityCart;
        if(quantityCart!=widget.quantity){
          quantityCounter = quantityCart+1;
          await documentRef.update({'quantity': FieldValue.increment(1)});
          refreshScreen();
        }
        
      } else {
          try{
          final data = await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).add({
          'id':widget.id,
          'price':widget.price,
          'quantity':1,
          'title':widget.title,
          'type':'cart',
          });
          }on FirebaseException catch(e){
            print(e);
          }
          quantityCounter = 1;
      }  
  }

  Future<void> decreaseQuantity()async{
    CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot querySnapshot = await collection.where('id', isEqualTo: widget.id).get();
    String documentId = querySnapshot.docs.first.id;
    DocumentReference documentRef = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(documentId);
    int quantityCart =await quantityCal();
    
    refreshScreen();
    if(quantityCart>1){
      quantityCounter=quantityCart-1;
      await documentRef.update({'quantity': FieldValue.increment(-1)});
    }
    else{
      quantityCounter=0;
      await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(documentId).delete();
      refreshScreen();
    }
  }


  @override
  Widget build(BuildContext context) {
    Widget cartBar = Center(
          child: CircularProgressIndicator(),
        );
    if(isLoading==false){
      if(quantityCounter>=1){
        cartBar=Row(
          children: [
          IconButton(onPressed: ()async{await updateQuantity();}, icon:Icon(Icons.add)),
          Text(quantityCounter.toString(),style: TextStyle(fontSize: 8,),),
          IconButton(onPressed: ()async{await decreaseQuantity();}, icon:Icon(Icons.remove)),
          ],
        );
      }
      else{
          cartBar=ElevatedButton(onPressed: ()async{
                await updateQuantity();
                refreshScreen();
              }, 
              child:const Text('add to cart'),
            );
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('KashuKart'),
      ),
      body: Column(
        children: [
          Text(widget.title),
          Text(widget.price.toString()),
          cartBar,
        ],
      ),

    );
  }
}
