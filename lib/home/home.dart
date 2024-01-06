import 'dart:async';

import 'package:asal/auth/loading.dart';
import 'package:asal/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:asal/home/mytextimage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


late Timer _timer;
// ignore: non_constant_identifier_names
Future<void> AddUser(
    String mytype, String myname, String mylink, String myprice) async {
  await FirebaseFirestore.instance.collection(mytype).add({
    'name': myname, // John Doe
    'price': myprice, // Stokes and Sons
    'link': mylink // 42
  }).then((value) {
    if (kDebugMode) {
      print("=================================================User Added");
    }
  }).catchError((error) {
    if (kDebugMode) {
      print(
          "=========================================Failed to add user: $error");
    }
  });
}

Future<void> addtype(String mytype) async {
  await FirebaseFirestore.instance.collection("types").add({
    'name': mytype,
  }).then((value) {
    if (kDebugMode) {
      print("=================================================types Added");
    }
  }).catchError((error) {
    if (kDebugMode) {
      print(
          "=========================================Failed to add types: $error");
    }
  });
}

void myadd(String title, Map<int, Map<String, String>> x) async {
  for (int j = 0; j < x.length; j++) {
    if (x[j] != null) {
      if (x[j]?["name"] == null) return;
      if (x[j]?["price"] == null) return;
      if (x[j]?["link"] == null) return;

      Map<String, String> m = x[j] ?? {"ERROR": "ERROR"};

      String nm = m["name"] ?? "ERROR";
      String pr = m["price"] ?? "ERROR";
      String lk = m["link"] ?? "ERROR";

      if (nm == "ERROR" || pr == "ERROR" || lk == "ERROR") return;

      await AddUser(title, nm, lk, pr);
    }
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  bool isloading = true;
  bool isgettingtypes = true;

  List<List<QueryDocumentSnapshot>> data = [];
  List<QueryDocumentSnapshot> types = [];

  Future<void> gettypes() async {
    types.clear();
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection("types").get();
    types.addAll(snap.docs);
    getdata();
  }

  Future<void> getdata() async {
    data.clear();
    for (int i = 0; i < types.length; i++) {
      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection(types[i]["name"]).get();
      List<QueryDocumentSnapshot> temp = [];
      temp.addAll(snap.docs);
      data.add(temp);
    }

    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    gettypes();
  }

  @override
  Widget build(BuildContext context) {
      _timer = Timer.periodic(const Duration(minutes: 5), ((timer) async{
     gettypes();

    }));
    //getdata();
    // if(isloading) return const CircularProgressIndicator();
    if (isloading) {
      return const Scaffold(
        body: Center(
          child: ExampleUiLoadingAnimation(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(134, 4, 112, 85),
 
      //drawerScrimColor: Colors.white,
      leading: Builder(
          builder: (context){
            return IconButton(
              icon: const Icon(Icons.settings,color: Colors.white),
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context){
              return IconButton(
                icon: const Icon( Icons.replay_outlined,color: Colors.white),
                onPressed: ()async{
                  //Scaffold.of(context).openEndDrawer();
                  isloading = true;
                  await gettypes();
                  setState(() {
                    
                  });
                },
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        //surfaceTintColor: Colors.white,

        backgroundColor: const Color.fromARGB(133, 23, 115, 92),

        child: isloading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  const SizedBox(
                    width: 25,
                    height: 75,
                  ),
                  const Text(
                    "help",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const Divider(
                      color: Colors.white,
                      thickness: 1,
                      indent: 25,
                      endIndent: 25),
                  MaterialButton(
                      child: const Text(
                        "log out",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        GoogleSignIn gsn = GoogleSignIn();
                        gsn.disconnect();
                        await FirebaseAuth.instance.signOut();
                        if (!context.mounted) return;
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const Login(),
                          ),
                        );
                      }),
                  const Divider(
                      color: Colors.white,
                      thickness: 1,
                      indent: 25,
                      endIndent: 25),
                ],
              ),
      ),
      endDrawer: const Drawer(
        backgroundColor: const Color.fromARGB(133, 23, 115, 92),
      ),
    
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(134, 4, 112, 85),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            // ignore: use_build_context_synchronously
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController linkimg = TextEditingController();
                  TextEditingController newprice = TextEditingController();
                  TextEditingController newname = TextEditingController();
                  TextEditingController newtitle = TextEditingController();

                  return AlertDialog(
                    content: Container(
                      height: 250,
                      width: 250,
                      child: ListView(
                        //mainAxisSize: MainAxisSize.min,

                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(backgroundColor: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Enter type name ",
                              labelStyle: TextStyle(
                                  //color: Colors.white,
                                  backgroundColor: Colors.white24),
                            ),
                            autofocus: true,
                            controller: newtitle,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(backgroundColor: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Enter new name ",
                              labelStyle: TextStyle(
                                  //color: Colors.white,
                                  backgroundColor: Colors.white24),
                            ),
                            autofocus: true,
                            controller: newname,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(backgroundColor: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Enter new price ",
                              labelStyle: TextStyle(
                                  // color: Colors.white,
                                  backgroundColor: Colors.white24),
                            ),
                            autofocus: true,
                            controller: newprice,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(backgroundColor: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Enter link for image ",
                              labelStyle: TextStyle(
                                  // color: Colors.white,
                                  backgroundColor: Colors.white24),
                            ),
                            autofocus: true,
                            controller: linkimg,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        child: const Text(
                          "ok",
                        ),
                        onPressed: () async {
                          if (!types.contains(newtitle.text)) {
                            addtype(newtitle.text);
                          }
                          await AddUser(newtitle.text, newname.text,
                              linkimg.text, newprice.text);

                          setState(() {
                            isloading = true;
                            gettypes();
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      ElevatedButton(
                        child: const Text(
                          "Cancel",
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          }),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: types.length,
          itemBuilder: (context, index) {
            //print("=======================================>");
            // print(datacars.length);
            return Kind(prod: data[index], titles: types[index]["name"]);
          },
        ),
      ),
    );
  }
}
