
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_project/popups/error.dart';
import 'package:practice_project/screens/login.dart';
import 'package:practice_project/screens/profile.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = true;

  @override
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showFunction(){
    setState(() {
      showPassword=!showPassword;
    });
  }

  Future<void> createAcount() async{
    try{
      showDialog(context: context, builder: (context){return const Center(child: CircularProgressIndicator(color: Colors.blue,),);});
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailIdController.text.trim(), password: _passwordController.text.trim());
      print(userCredential);
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailIdController.text.toLowerCase().trim(), password: _passwordController.text.trim());
      Navigator.of(context).pop();
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
    }on FirebaseAuthException catch (e){
      if(e.code=='email-already-in-use'){
        showToast(message:'Email is already in use');
        Navigator.of(context).pop();
      }
      else{
        showToast(message:'An etror occured ${e.code}');
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Image.asset('assets/images/loading.png'),
            TextField(
              cursorColor: Colors.blue,
              controller: _emailIdController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 2,color: Colors.blue),
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'email id',
                labelText: 'email id',
                labelStyle: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              cursorColor: Colors.blue,
              obscureText: showPassword,
              controller: _passwordController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 2,color: Colors.blue,),
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIconColor: Colors.blue,
                hintText: 'password',
                labelText: 'password',
                labelStyle: TextStyle(color: Colors.blue),
                suffixIcon: IconButton(onPressed: (){
                    showFunction();
                  },icon: Icon(showPassword == false ? Icons.visibility : Icons.visibility_off))
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: ()async{
              await createAcount();
            },
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: const Text('Sign up',style: TextStyle(color: Colors.white),)),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
              },
              child: Text('Already have an account?',style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue,decorationColor: Colors.blue)
            ),
            )
          ],
        ),
      ),
    );
  }
}