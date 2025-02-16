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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Enter full name'),
                ),
                TextField(
                  controller: _numberController,
                  decoration: const InputDecoration(hintText: 'Enter Your Phone Number'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(hintText: 'Enter Your Address'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: addDetails,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
    );
  }
}