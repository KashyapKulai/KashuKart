import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice_project/screens/login.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {

  bool hasProfile = false;
  bool isLoading = true; 
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    profileChecker();
  }

  

  Future<void> profileChecker() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference collection = FirebaseFirestore.instance.collection(userId);
    QuerySnapshot querySnapshot = await collection.where('type', isEqualTo: 'profile').get();
    if (querySnapshot.docs.isNotEmpty) {
      String documentId = querySnapshot.docs.first.id;
      Map<String, dynamic>? fetchedData = await storeDetails(documentId);
      if (fetchedData != null) {
        setState(() {
          profileData = fetchedData;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        profileData = null;
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> storeDetails(String documentId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(documentId)
        .get();
    return documentSnapshot.data() as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator(color: Colors.blue,)),
      );
    } else {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${profileData?['name']}", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text("Phone Number: ${profileData?['ph']}", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text("Address: ${profileData?['address']}", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (context)=> AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: (){
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),);
                            }, 
                            child: Text('Yes'),
                          ),
                          TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('No'))
                        ],
                        title: Text('Sign Out'),
                        contentPadding: EdgeInsets.all(16.0),
                        content: Text('Are you Sure'),
                      )
                    );
                    
                  }, 
                  child: Text('Sign Out'),
                ),
              ],
            ),
          ),
        );
    }
  }
}
