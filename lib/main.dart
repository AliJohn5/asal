import 'package:asal/auth/login.dart';
import 'package:asal/firebase_options.dart';
import 'package:asal/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

const bool useemulator = false;

Future connectemulator() async
{
  const localhoststring = '127.0.0.1';

  FirebaseFirestore.instance.settings =const Settings(
    host: '$localhoststring:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );
  await FirebaseAuth.instance.useAuthEmulator(localhoststring, 9099);
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
);

if(useemulator)
{
  await connectemulator();
}
 /*await FirebaseAppCheck.instance.activate(
    // Set appleProvider to `AppleProvider.debug`
    appleProvider: AppleProvider.debug,
  );*/

//await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
User? user = FirebaseAuth.instance.currentUser;
bool f = user == null;
if(user!= null)
{
  if(!user.emailVerified)
  {
    f = true;
    GoogleSignIn gsn = GoogleSignIn();
    gsn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
  else
  {
    f = false;
  }
}

  return runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: f? const Login():  Home()
  ));
}
