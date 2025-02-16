import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice_project/popups/error.dart';
import 'package:practice_project/screens/sign_up.dart';
import 'package:practice_project/screens/tab_screen.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailId = TextEditingController();

  final TextEditingController _password = TextEditingController();

  bool showPassword=true;

  @override
  void dispose() {
    _emailId.dispose();
    _password.dispose();
    super.dispose();
  }

  void showFunction(){
    setState(() {
      showPassword=!showPassword;
    });
  }

  Future<void> loginUserWithEmailPassword() async{
    try{
      showDialog(context: context, builder: (context){return const Center(child: CircularProgressIndicator(color: Colors.blue,),);});
      final userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailId.text.trim(), password: _password.text.trim());
      print(userCredential);
      Navigator.of(context).pop();
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Tabscreen(),
      ));
    }on FirebaseAuthException catch (e){
      if(e.code=='invalid-credential'){
        print(e.message);
        print('hi');
        showToast(message:'Invalid Email Or Password');
        Navigator.of(context).pop();
      }
      else{
        print(e.code);
        print('hello');
        showToast(message:'An error occured ${e.code}');
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
              controller: _emailId,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 2,color: Colors.blue),
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'email id',
                labelStyle: TextStyle(color: Colors.blue),
                hintText: 'email id',
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              obscureText: showPassword,
              controller: _password,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 2,color: Colors.blue),
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)
              ),
              onPressed: () async{
                await loginUserWithEmailPassword();
              }, 
              child: const Text('Sign in',style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
              },
              child: Text('Create an Account',style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue,decorationColor: Colors.blue)
            ),
            )
          ],
        ),
      ),
    );
  }
}