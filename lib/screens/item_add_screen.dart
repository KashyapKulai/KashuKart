import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice_project/screens/sign_up.dart';

class AddItemScreen extends StatefulWidget{
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _itemName = TextEditingController();

  final TextEditingController _price= TextEditingController();
  final TextEditingController _quantity= TextEditingController();

  Future<void> addToList()async{
    try{
      final data = await FirebaseFirestore.instance.collection('items').add({
        'itemName':_itemName.text.trim(),
        'price':_price.text.trim(),
        'quantity':_quantity.text.trim(),
      });
    }on FirebaseException catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    _itemName.dispose();
    _price.dispose();
    _quantity.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add screen'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _itemName,
            decoration: const InputDecoration(
              hintText: 'item name',
            ),
          ),
          TextField(
            controller: _price,
            decoration: const InputDecoration(
              hintText: 'price',
            ),
          ),
          TextField(
            controller: _quantity,
            decoration: const InputDecoration(
              hintText: 'quantity',
            ),
          ),
          ElevatedButton(
            onPressed: () async{
              await addToList();
            }, 
            child: const Text('add'),
          ),
        ],
      ),
    );
  }
}