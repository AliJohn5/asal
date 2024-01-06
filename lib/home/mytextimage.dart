import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
late Timer _timer;
String errorurl =
    "https://st.depositphotos.com/1575949/4950/v/950/depositphotos_49506497-stock-illustration-error-red-stamp-text.jpg";

String errorname = "ERROR";
String errorpric = "\$\$\$\$";

List<String> deleted = [];

class OnPressedImage extends StatefulWidget {
  const OnPressedImage(
      {required this.singleprod,
      required this.titl,
      required this.id_,
      Key? key, required this.onButtonPressed})
      : super(key: key);

  final Map<String, String> singleprod;
  final String id_;
  final String titl;
  final Function(String) onButtonPressed;

  @override
  State<OnPressedImage> createState() => _OnPressedImage();

  // _OnPressedImage(url: url, lasturl: lasturl,todowhentap: todowhentap);
}

class _OnPressedImage extends State<OnPressedImage> {
  bool isloading = false;

  Future<void> update() async {
    isloading = true;
    DocumentSnapshot<Map<String, dynamic>> snap = 
    await FirebaseFirestore.instance.collection(widget.titl).doc(widget.id_).get();

    widget.singleprod["name"] = snap["name"];
    widget.singleprod["price"] = snap["price"];
    widget.singleprod["link"] = snap["link"];
    setState(() {
    isloading = false;
    });

  }
@override

  
  Future<void> delet() async {
    isloading = true;
    
    await FirebaseFirestore.instance.collection(widget.titl).doc(widget.id_).delete();
    deleted.add(widget.id_);
    widget.singleprod["name"] = "";
    widget.singleprod["price"] = "";
    widget.singleprod["link"] = "";
    widget.onButtonPressed(widget.id_);
    isloading = false;
  }

  @override
  Widget build(BuildContext context) {
     _timer = Timer.periodic(const Duration(seconds: 3), ((timer) async{
       DocumentSnapshot<Map<String, dynamic>> snap = 
    await FirebaseFirestore.instance.collection(widget.titl).doc(widget.id_).get();

if(
     widget.singleprod["name"] != snap["name"] ||
    widget.singleprod["price"] != snap["price"] ||
    widget.singleprod["link"] != snap["link"]){
      update();

    }

    }));
    //String editurl = "";

     if (isloading) {
    return  const Center(
        child:CircularProgressIndicator(),
    );
  }

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10, left: 10, top: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(133, 181, 161, 195),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      height: 175,
      width: 175,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          SizedBox(
            height: 175,
            width: 170,
            child: Image.network(
              widget.singleprod["link"] ?? errorurl,
              //errorurl,
              fit: BoxFit.cover,
              scale: 4,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                // Custom error widget to display when image loading fails
                // print(exception);

                return Image.network(
                  errorurl,
                  fit: BoxFit.cover,
                );
              },
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child; // Image is still loading, return default placeholder
                }
                return const CircularProgressIndicator(
                  strokeWidth: 2,
                ); // Show a loading indicator
              },
            ),
          ),
          Container(
            height: 50, // Adjust the height of the white overlay
            color: const Color.fromARGB(37, 255, 255, 255)
                .withOpacity(0.7), // Adjust the opacity if needed
          ),
          Positioned(
            left: 5,
            bottom: 25,
            child: Text(
              textAlign: TextAlign.left,
              widget.singleprod["name"] ?? errorname,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Adjust the color if needed
              ),
            ),
          ),
          Positioned(
            left: 5,
            bottom: 10,
            child: Text(
              textAlign: TextAlign.left,
              widget.singleprod["price"] ?? errorpric,
              style: const TextStyle(
                fontSize: 16,

                color: Colors.black,
                // Adjust the color if needed
              ),
            ),
          )
        ]),
        onTap: () {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController linkimg = TextEditingController();
                  TextEditingController newprice = TextEditingController();
                  TextEditingController newname = TextEditingController();

                  return AlertDialog(
                    content: Container(
                      height: 600,
                      width: 250,
                      child: ListView(
                        //mainAxisSize: MainAxisSize.min,

                        children: [
                          Stack(alignment: Alignment.bottomCenter, children: [
                            SizedBox(
                              height: 250,
                              width: 250,
                              child: Image.network(
                                widget.singleprod["link"] ?? errorurl,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  // Custom error widget to display when image loading fails

                                  return Image.network(
                                    errorurl,
                                    fit: BoxFit.cover,
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Image is still loading, return default placeholder
                                  }
                                  return const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ); // Show a loading indicator
                                },
                              ),
                            ),
                            Container(
                              height:
                                  50, // Adjust the height of the white overlay
                              color: const Color.fromARGB(37, 255, 255, 255)
                                  .withOpacity(
                                      0.7), // Adjust the opacity if needed
                            ),
                            Positioned(
                              left: 5,
                              bottom: 25,
                              child: Text(
                                textAlign: TextAlign.left,
                                widget.singleprod["name"] ?? errorname,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .black, // Adjust the color if needed
                                ),
                              ),
                            ),
                            Positioned(
                              left: 5,
                              bottom: 10,
                              child: Text(
                                textAlign: TextAlign.left,
                                widget.singleprod["price"] ?? errorpric,
                                style: const TextStyle(
                                  fontSize: 16,

                                  color: Colors.black,
                                  // Adjust the color if needed
                                ),
                              ),
                            )
                          ]),

                          /* Container(
                                      width: 250,
                                      height: 75,
                                      color: Colors.amber,
                                    )*/
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

                        
                        onPressed: () {
                          setState(() async {
                            if (kDebugMode) {
                              print("===========================> 11");
                            }
                            if (widget.id_ == "ERROR") return;
                            if (kDebugMode) {
                              print("===========================> 12");
                            }
                            CollectionReference users = FirebaseFirestore
                                .instance
                                .collection(widget.titl);
                            if (kDebugMode) {
                              print("===========================> 13");
                            }
                            await users.doc(widget.id_).set({
                              "name": newname.text,
                              "price": newprice.text,
                              "link": linkimg.text
                            }).then((value) {
                              widget.singleprod["name"] = newname.text;
                              widget.singleprod["price"] = newprice.text;
                              widget.singleprod["link"] = linkimg.text;
                              update();
                              Navigator.of(context).pop();
                            });
                            if (kDebugMode) {
                              print("===========================> 14");
                            }
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: const Text(
                          "Cancel",
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                       ElevatedButton(
                        child: const Text(
                          "deleet",
                        ),
                        onPressed: () {
                          delet();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          });
        },
      ),
    );
  }
}

class Kind extends StatefulWidget
{
  Kind( {required this.prod,required this.titles,Key? key} ):super(key: key);
  late List<QueryDocumentSnapshot> prod;
  late String titles;
  @override
  State<Kind> createState() => _Kind();
}

class _Kind extends State<Kind>
{
  @override
  Widget build(BuildContext context) {
    return  Column(
    children: [
      Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: const BoxDecoration(
          color: Color.fromARGB(134, 4, 112, 85),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        alignment: Alignment.center,
        height: 30,
        width: 200,
        child: Text(
         widget.titles,
          style: GoogleFonts.dancingScript(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(
        height: 2,
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: const BoxDecoration(
          color: Color.fromARGB(134, 23, 158, 195),
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 30,
              offset: Offset(5, 10), // Shadow position
            ),
          ],
        ),
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.prod.length,
          itemBuilder: (context, index) {
            
            if( !deleted.contains(widget.prod[index].id) ){

            Map<String, String> m = {
              "name": widget.prod[index]["name"],
              "price": widget.prod[index]["price"],
              "link": widget.prod[index]["link"],
            };
            String id__ = widget.prod[index].id;

            return OnPressedImage(
              singleprod: m,
              id_: id__,
              titl: widget.titles,
              onButtonPressed: (value) {
                setState(() {
                widget.prod.removeAt(index);
                });
              },
            );
            }
          },
        ),
      ),
    ],
  );
  }

}
/*

Widget mytemxtimage(List<QueryDocumentSnapshot> prod, String titles) {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: const BoxDecoration(
          color: Color.fromARGB(134, 4, 112, 85),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        alignment: Alignment.center,
        height: 30,
        width: 200,
        child: Text(
          titles,
          style: GoogleFonts.dancingScript(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(
        height: 2,
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: const BoxDecoration(
          color: Color.fromARGB(134, 23, 158, 195),
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 30,
              offset: Offset(5, 10), // Shadow position
            ),
          ],
        ),
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: prod.length,
          itemBuilder: (context, index) {
            
            if( !deleted.contains(prod[index].id) ){

            Map<String, String> m = {
              "name": prod[index]["name"],
              "price": prod[index]["price"],
              "link": prod[index]["link"],
            };
            String id__ = prod[index].id;

            return OnPressedImage(
              singleprod: m,
              id_: id__,
              titl: titles,
            );
            }
          },
        ),
      ),
    ],
  );
}
*/