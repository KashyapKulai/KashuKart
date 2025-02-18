import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practice_project/screens/item_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  String name='';
  bool _isloading=true;

    @override
    void initState() {
      super.initState();
      _callAsyncFunction();
    }

    Future<void> _callAsyncFunction() async {
      print('hi');
      String data = await profileName(); 
      setState(() {
        name = data;
        _isloading=false;
        print(name);
      });
    }

    Future<String> profileName() async{
      String name='';
      CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
      QuerySnapshot querySnapshot = await collection.where('type', isEqualTo: 'profile').get();
      if (querySnapshot.docs.isNotEmpty ) {
          String documentId = querySnapshot.docs.first.id;
          DocumentReference documentRef = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(documentId);
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(documentId)
          .get();
          name = documentSnapshot.get('name');
      }
      return name;
    }

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

    Widget profileWidget = CircularProgressIndicator(color: Colors.blue,);

    if(_isloading==false){
      profileWidget=Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Center(child: Text(name[0],style: TextStyle(color: Colors.white,fontSize: 30),)),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle
                  ),
                ),
                SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome',style: TextStyle(fontSize: 17),),
                    Text('${name}!',style: TextStyle(fontSize: 17),)
                  ],
                )
              ],
            );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            profileWidget,
            SizedBox(height: 15,),
            TextField(
              cursorColor: Colors.blue,
              decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(width: 2,color: Colors.blue),
              ),
              focusedBorder:OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'search',
              labelText: 'search',
              labelStyle: TextStyle(color: Colors.blue),
              prefixIcon: Icon(Icons.search),
              prefixIconColor: Colors.blue
              ),
            ),
            SizedBox(height: 15,),
            CarouselSlider.builder(
              itemCount: urlImages.length, 
              itemBuilder: (context,index,realIndex){
                return buildImage(urlImages[index], index);
              }, 
              options: CarouselOptions(
                viewportFraction: 1,
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
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 8.0, // Spacing between columns
                      mainAxisSpacing: 8.0, // Spacing between rows
                      childAspectRatio: 1.0, // Aspect ratio of each grid item
                    ),
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
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  itemData['item'],
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '₹${itemData['price']}',
                                  style: TextStyle(fontSize: 14, color: Colors.green),
                                ),
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
      ),
    );
  }
}