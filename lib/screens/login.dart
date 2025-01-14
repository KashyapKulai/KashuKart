import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice_project/screens/sign_up.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailId = TextEditingController();

  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _emailId.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> loginUserWithEmailPassword() async{
    try{
      final userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailId.text.trim(), password: _password.text.trim());
      print(userCredential);
    }on FirebaseAuth catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _emailId,
            decoration: const InputDecoration(
              hintText: 'email id',
            ),
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
              hintText: 'password',
            ),
          ),
          ElevatedButton(
            onPressed: () async{
              await loginUserWithEmailPassword();
            }, 
            child: const Text('Sign in'),
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpScreen(),
              ),
            );
          }, child: const Text('Create Account')),
        ],
      ),
    );
  }
}