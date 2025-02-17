import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practice_project/screens/item_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final urlImages=[
    'https://picsum.photos/id/1/200/300',
    'https://picsum.photos/id/2/200/300',
    'https://picsum.photos/id/3/200/300',
    'https://picsum.photos/id/4/200/300',
    'https://picsum.photos/id/5/200/300',
];

  @override
  Widget build(BuildContext context) {

    Widget buildImage(String imageUrl,int index)=>Container(
      width:MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(horizontal: 5),
      color: Colors.grey,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CarouselSlider.builder(
            itemCount: urlImages.length, 
            itemBuilder: (context,index,realIndex){
              return buildImage(urlImages[index], index);
            }, 
            options: CarouselOptions(
              height: 150,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(seconds: 3),
            )
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('items').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.blue,));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data Present'));
              }
          
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var itemData = snapshot.data!.docs[index].data();
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemScreen(
                              id: itemData['id'],
                              title: itemData['item'],
                              price: itemData['price'],
                              quantity: itemData['quantity'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Column(
                            children: [
                              Text(itemData['item']),
                              Text('₹${itemData['price']}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}