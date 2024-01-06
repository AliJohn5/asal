import "package:asal/auth/loading.dart";
import "package:asal/auth/login.dart";
import "package:asal/auth/customlabel.dart";
import "package:asal/auth/verefied.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import 'package:firebase_auth/firebase_auth.dart';

String signuperror = "Some thing wrong with sign up";

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
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
  TextEditingController confpass = TextEditingController();
  final formKeyemail = GlobalKey<FormState>();
  final formKeypass = GlobalKey<FormState>();
  final formKeyconfpass = GlobalKey<FormState>();

  String? emailvaled(String? value) {
    if (value == null || value.isEmpty) {
      return "please write your Email";
    }
    if(value[0]==' ' || value[value.length-1]==' ')
    {
      return "can't contain spaces";
    }
    return null;
  }

  String? passvaled(String? value) {
    if (value == null || value.isEmpty) {
      return "please write password";
    }

    if (value.length < 8) {
      return "password at least 8 charecters";
    }
     if(value.contains(' '))
    {
      return "can't contain spaces";
    }
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return null;
    }

    return "password must contain at lest one of each:\nlower ,upper, number, sympol ( ! @ #  & * ~ )";
  }

  String? confpassvaled(String? value) {
    if (value != pass.text) {
      return "password is different";
    }

    return null;
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
            Column(
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
                CustomLabel(
                  hittext: "********",
                  title: "Confirm password",
                  cont: confpass,
                  ispassword: true,
                  formKey: formKeyconfpass,
                  validetext: confpassvaled,
                ),
                const SizedBox(
                  height: 5,
                ),
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
                          "Sign up",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        )),
                    onPressed: () async {
                      if (formKeyemail.currentState!.validate() &&
                          formKeypass.currentState!.validate() &&
                          formKeyconfpass.currentState!.validate()) {
                        showDialogue(context);
                        try {
                          // ignore: unused_local_variable
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: pass.text,
                          )
                              .then((value) async {
                            f = false;
                            User? user = FirebaseAuth.instance.currentUser;

                            if (user != null && !user.emailVerified) {
                              await user.sendEmailVerification();
                            }
                            
                            hideProgressDialogue(context);
                            Route route = MaterialPageRoute(
                                builder: (context) => const Verifiedwidget());
                            Navigator.pushReplacement(context, route);
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            //print('The password provided is too weak.');
                            signuperror = 'The password provided is too weak.';
                          } else if (e.code == 'email-already-in-use') {
                            //print('The account already exists for that email.');
                            signuperror =
                                'The account already exists for that email.';
                          }
                          else
                          {
                            if(e.message != null){
                            signuperror = e.message as String;
                            }
                          }
                        } 
                        if (f) {
                          setState(() {
                            hideProgressDialogue(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(signuperror)));
                          });
                        }
                      }
                    }),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have account?",
                      style: TextStyle(fontSize: 15),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => const Login());
                        Navigator.pushReplacement(context, route);
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(135, 4, 89, 112),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
