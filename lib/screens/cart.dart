import 'package:flutter/material.dart';
import 'package:practice_project/models/cart_item.dart';
import 'package:practice_project/screens/item_screen.dart';
class CartScreen extends StatefulWidget{
 const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void refreshScreen() {
      setState(() {
      // This will trigger a rebuild and reflect any changes to the `items`.
      });
    }
  @override
  Widget build(BuildContext context) {

    Widget cartCondition = const Center(child: Text('Cart is empty'));

    if(cart.isNotEmpty){
      cartCondition=ListView.builder(
        itemCount: cart.length,
        itemBuilder:(context,index){
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemScreen(item: cart[index]),
                ),
              ).then((_) {
                // Refresh the screen after returning from ItemScreen
                refreshScreen();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(0.8),
              child: Column(
                children: [
                  Text(cart[index].title),
                  Text(cart[index].amount.toString()),
                  Text(cart[index].quantity.toString()),
                ],
              ),
            ),
          );
        },
      );
    }
    
    return Scaffold(
      body: cartCondition
    );
  }
}