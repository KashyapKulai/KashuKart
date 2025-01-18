import 'package:flutter/material.dart';
import 'package:practice_project/firebase_options.dart';
import 'package:practice_project/screens/login.dart';
//import 'package:practice_project/screens/sign_up.dart';
import 'package:practice_project/screens/tab_screen.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const TempController());
}

class TempController extends StatelessWidget{
  const TempController({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
             stream: FirebaseAuth.instance.authStateChanges(),
             builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                print('loading');
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(snapshot.data!=null){
                print('Hello');
                return const Tabscreen();
              }
              print('hi');
              return const LoginScreen();
             }
            ),
    );
  }
}