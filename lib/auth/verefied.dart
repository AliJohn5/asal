import "dart:async";

import "package:asal/auth/signup.dart";
import "package:asal/home/home.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:google_sign_in/google_sign_in.dart";

late Timer _timer;

class Verifiedwidget extends StatefulWidget {
  const Verifiedwidget({Key? key}) : super(key: key);

  @override
  State<Verifiedwidget> createState() => _Verifiedwidget();
}

class _Verifiedwidget extends State<Verifiedwidget> {
  @override
  Widget build(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 3), ((timer) {
      FirebaseAuth.instance.currentUser?.reload();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (user.emailVerified) {
          timer.cancel();
          Route route = MaterialPageRoute(builder: (context) =>  Home());
          Navigator.pushReplacement(context, route);
        }
      }
    }));
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
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    "We send you a email for virefing your sign up\nplease copy the link and open it in browser.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dancingScript(
                        color: const Color.fromARGB(255, 117, 82, 246),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                MaterialButton(
                    hoverColor: Colors.white,
                    child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 200,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(135, 4, 89, 112),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: const Text(
                          "Go back",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        )),
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;
                      await user?.delete();
                      GoogleSignIn gsn = GoogleSignIn();
                      gsn.disconnect();
                      await FirebaseAuth.instance.signOut();

                      Route route = MaterialPageRoute(
                          builder: (context) => const Signup());
                      Navigator.pushReplacement(context, route);
                    }),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                    hoverColor: Colors.white,
                    child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 200,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(135, 4, 89, 112),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: const Text(
                          "resend email",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        )),
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null && !user.emailVerified) {
                        await user.sendEmailVerification();
                      }
                    }),
              ],
            ),
          ],
        ));
  }
}
