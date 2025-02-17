import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice_project/screens/tab_screen.dart';
class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> addDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .add({
        'name': _nameController.text,
        'ph': _numberController.text.trim(),
        'address': _addressController.text,
        'type': 'profile',
      });
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Tabscreen(),
      ),
    );

    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Image.asset('assets/images/loading.png'),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(width: 2,color: Colors.blue),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter full name'
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextField(
                    controller: _numberController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(width: 2,color: Colors.blue),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Your Phone Number',
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(width: 2,color: Colors.blue),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Your Address',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)
                    ),
                    onPressed: addDetails,
                    child: const Text('Save',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}