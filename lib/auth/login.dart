import "package:asal/auth/fogetpass.dart";
import "package:asal/auth/loading.dart";
import "package:asal/home/home.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import 'package:google_fonts/google_fonts.dart';
import "package:asal/auth/customlabel.dart";
import "package:asal/auth/signup.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";

String loginerror = "Some thing wrong with sign in";


Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  if(googleUser == null) return;

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  await FirebaseAuth.instance.signInWithCredential(credential);
  return;
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) {
          print('User is currently signed out!');
        }
      } else {
        if (kDebugMode) {
          print('User is signed in!');
        }
      }
    });
    super.initState();
  }

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final formKeyemail = GlobalKey<FormState>();
  final formKeypass = GlobalKey<FormState>();
  String? emailvaled(String? value) {
    if (value == null || value.isEmpty) {
      return "please write your Email";
    }
    return null;
  }

  String? passvaled(String? value) {
    if (value == null || value.isEmpty) {
      return "please write password";
    }
    if(value[0]==' ' || value[value.length-1]==' ')
    {
      return "can't contain spaces";
    }

    if (value.length < 8) {
      return "password at least 8 charecters";
    }

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return null;
    }

    return "password must contain at lest one of each:\nlower ,upper, number, sympol ( ! @ #  & * ~ )";
  }

  void showDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const ExampleUiLoadingAnimation(),
    );
  }

  void hideProgressDialogue(BuildContext context) {
    Navigator.of(context).pop(const ExampleUiLoadingAnimation());
  }

  
  void showDialogue1(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>d);
  }

  void hideProgressDialogue1(BuildContext context) {
    Navigator.of(context).pop(d);
  }


  @override
  Widget build(BuildContext context) {
    bool f = true;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(135, 4, 89, 112),
          centerTitle: true,
          title: const Text("ASAL", style: TextStyle(color: Colors.white)),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 140,
              child: Center(
                child: Image.asset(
                  "images/logo.png",
                  scale: 1,
                ),
              ),
            ),
            Container(
              height: 60,
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  "Welcome!!\nWe are happy seeing you use our app",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dancingScript(
                      color: const Color.fromARGB(255, 117, 82, 246),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            CustomLabel(
              title: "Email",
              hittext: "example@gmail.com",
              cont: email,
              ispassword: false,
              formKey: formKeyemail,
              validetext: emailvaled,
            ),
            CustomLabel(
              hittext: "********",
              title: "password",
              cont: pass,
              ispassword: true,
              formKey: formKeypass,
              validetext: passvaled,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  onPressed: () {
                    Route route = MaterialPageRoute(
                            builder: (context) => const Forgetpassword());
                        Navigator.pushReplacement(context, route);
                  },
                  child: const Text(
                    "Foget password?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(135, 4, 89, 112),
                    ),
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
                hoverColor: Colors.white,
                child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(135, 4, 89, 112),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    )),
                onPressed: () async {
                  if (formKeyemail.currentState!.validate() &&
                      formKeypass.currentState!.validate()) {
                    try {
                      // ignore: unused_local_variable

                      // ignore: unused_local_variable
                      showDialogue(context);
                      // ignore: unused_local_variable
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: pass.text)
                          .then((value) {
                        f = false;
                        hideProgressDialogue(context);
                        Route route = MaterialPageRoute(
                            builder: (context) =>  Home());
                        Navigator.pushReplacement(context, route);
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        if (kDebugMode) {
                          print('No user found for that email.');
                        }

                        loginerror = "No user found for that email.";
                      } else if (e.code == 'wrong-password') {
                        if (kDebugMode) {
                          print('Wrong password provided for that user.');
                        }

                        loginerror = "Wrong password provided for that user.";
                      }
                      else
                      {
                        if(e.message != null)
                        {
                          loginerror = e.message as String;
                        }
                      }
                    } 

                    if (f) {
                      setState(() {
                        hideProgressDialogue(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(loginerror)));
                      });
                    }
                  }
                }),
            const SizedBox(
              height: 5,
            ),
            MaterialButton(
                hoverColor: Colors.white,
                child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(133, 74, 53, 148),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: const Text(
                      "Sign in with google",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                onPressed: () async {
                   showDialogue1(context);
                  try{
                  await signInWithGoogle().then((value){
                   
                    f = false;
                        hideProgressDialogue1(context);
                        Route route = MaterialPageRoute(
                            builder: (context) =>  Home());
                        Navigator.pushReplacement(context, route);

                  });
                  } on FirebaseAuthException catch(e)
                  {
                    if(e.message != null)
                    {
                          loginerror = e.message as String;
                    }
                  }
                 if (f) {
                      setState(() {
                        hideProgressDialogue(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(loginerror)));
                      });
                 }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have account?",
                  style: TextStyle(fontSize: 15),
                ),
                MaterialButton(
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => const Signup());
                    Navigator.pushReplacement(context, route);
                  },
                  child: const Text(
                    "Regester",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(135, 4, 89, 112),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
