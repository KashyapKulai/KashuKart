import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddItemScreen extends StatefulWidget{
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String uuid = Uuid().v4();
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _price= TextEditingController();
  final TextEditingController _quantity= TextEditingController();

  void idGenerator(){
    setState(() {
      uuid=Uuid().v4();
    });
  }

  Future<void> addToList()async{
    try{
      final data = await FirebaseFirestore.instance.collection('items').add({
        'item':_itemName.text.trim(),
        'price':int.parse(_price.text.trim()),
        'quantity':int.parse(_quantity.text.trim()),
        'id':uuid,
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
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'price',
            ),
          ),
          TextField(
            controller: _quantity,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'quantity',
            ),
          ),
          ElevatedButton(
            onPressed: () async{
              idGenerator();
              await addToList();
            }, 
            child: const Text('add'),
          ),
        ],
      ),
    );
  }
}