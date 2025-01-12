import 'package:flutter/material.dart';
import 'package:practice_project/models/item.dart';
import 'package:practice_project/models/cart_item.dart';
// ignore: must_be_immutable
class ItemScreen extends StatefulWidget{
  ItemScreen({super.key,required this.item});
  Items item;
  @override
  State<StatefulWidget> createState() {
    return _ItemSCreenState();
  }
}

class _ItemSCreenState extends State<ItemScreen>{

  void quantityR(){
    setState(() {
      widget.item.quantity-=1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('kashukart'),
      ),
      body: Column(
        children: [
          Text(widget.item.title),
          Text(widget.item.amount.toString()),
          Text(widget.item.quantity.toString()),
          ElevatedButton(onPressed: (){
            cart.add(widget.item);
          }, child:const Text('add to cart')),
          ElevatedButton(
            onPressed: (){
              quantityR();
            },
            child:const Text('Buy now')),
        ],
      ),
    );
  }
}