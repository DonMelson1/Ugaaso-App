import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Inside extends StatefulWidget {
  String title;
  String image;
  int price;
  List<int> color;
  List<String> size;
  int colors;
  int sizes;
  String id;
  Inside(
      {super.key,
      required this.title,
      required this.image,
      required this.price,
      required this.color,
      required this.colors,
      required this.id,
      required this.size,
      required this.sizes});

  @override
  State<Inside> createState() => _InsideState();
}

class _InsideState extends State<Inside> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int sizeSelected = 0;
  int colorSelected = 0;
  List<String> size = [];
  List<int> color = [];

  Future<void> addCard() async {
    String? urlImage = widget.image;
    String? titleImage = widget.title;
    int? price = widget.price;
    String? sizeCloth = size[sizeSelected];
    int? colorCloth = color[colorSelected];
    int? sizeIndex = sizeSelected;
    int? colorIndex = colorSelected;
    String id = FirebaseAuth.instance.currentUser!.uid;

    await firestore.collection("carts").doc(id).collection("carts").add({
      "url": urlImage,
      "title": titleImage,
      "price": price,
      "size": sizeCloth,
      "color": colorCloth,
      "sizeIndex": sizeIndex,
      "colorIndex": colorIndex,
      "count": 1,
      "id": widget.id,
      "colors": widget.colors,
      "sizes" : widget.sizes
    });
  }

  @override
  void initState() {
    super.initState(); // Always call super.initState()
    color = widget.color;
    size = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [
            Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                height: 450,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.image),
                        fit: BoxFit.fitHeight),
                    color: Color.fromARGB(255, 243, 118, 109),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                  ),
                )),

            //Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ListTile(
                title: Text(
                  widget.title,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 20),
                      fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  "${widget.price}\$",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 20),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            //Select Size Text
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Size",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 20),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            //Size
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
              child: Row(
                children: List.generate(size.length, (int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        sizeSelected = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: sizeSelected == index
                              ? Color.fromARGB(255, 249, 162, 155)
                              : null,
                          border: sizeSelected != index
                              ? Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        size[index],
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                      ),
                    ),
                  );
                }),
              ),
            ),

            //Spacer(),

            //Select Size Text
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Color",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 20),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            //selected color
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
              child: Row(
                children: List.generate(color.length, (int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        colorSelected = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color(color[index]),
                          border: colorSelected == index
                              ? Border.all(
                                  width: 4,
                                  color: Colors.red,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }),
              ),
            ),

            //Spacer(),

            //cart
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Builder(builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () async {
                        await addCard();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Check Your Cart"),
                          action: SnackBarAction(
                              label: "Ok",
                              onPressed: () {
                                runApp(Cart());
                              }),
                        ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 243, 118, 109),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Add to Cart",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 20),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
