
import "package:asal/auth/login.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import 'package:google_fonts/google_fonts.dart';
import "package:asal/auth/customlabel.dart";
import "package:flutter/material.dart";

String foregterror = "Some thing wrong with sign in";

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({Key? key}) : super(key: key);

  @override
  State<Forgetpassword> createState() => _Forgetpassword();
}

Widget d =const Center(
              heightFactor: 75,
              widthFactor: 75,
              child: CircularProgressIndicator(),
            );

class _Forgetpassword extends State<Forgetpassword> {
  TextEditingController email = TextEditingController();
  final formKeyemail = GlobalKey<FormState>();

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

  void showDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => d
    );
  }

  void hideProgressDialogue(BuildContext context) {
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
                      "Send Email",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    )),
                onPressed: () async {
                  if (formKeyemail.currentState!.validate()) {
                    try {
                      // ignore: unused_local_variable

                      // ignore: unused_local_variable
                      showDialogue(context);
                      // ignore: unused_local_variable
                      final credential = await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text)
                          .then((value) {
                        f = false;
                        hideProgressDialogue(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("reset email send succesfuly")));
                        Route route = MaterialPageRoute(
                            builder: (context) => const Login());
                        Navigator.pushReplacement(context, route);
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        if (kDebugMode) {
                          print('No user found for that email.');
                        }

                        foregterror = "No user found for that email.";
                      } else {
                        if (e.message != null) {
                          foregterror = e.message as String;
                        }
                      }
                    }

                    if (f) {
                      setState(() {
                        hideProgressDialogue(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(foregterror)));
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
                      color: Color.fromARGB(135, 4, 89, 112),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: const Text(
                      "back",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    )),
                onPressed: () async {
                  Route route =
                      MaterialPageRoute(builder: (context) => const Login());
                  Navigator.pushReplacement(context, route);
                }),
          ],
        ));
  }
}
