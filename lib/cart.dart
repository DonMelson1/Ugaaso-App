import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion/Home.dart';
import 'package:fashion/profile.dart';
import 'package:fashion/updateInside.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _currentBottom = 1;
  int count = 2;
  double total = 0.0;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<int> color = [];
  List<String> size = [];

  //to update count or number of cloth that user took
  Future<void> updateCount(String id) async {
    await FirebaseFirestore.instance
        .collection("carts")
        .doc(auth.currentUser!.uid)
        .collection("carts")
        .doc(id)
        .update({"count": count});
  }

  //to to get color and sizes that store in the dress storage
  Future<void> getColor(String id, int colors, int sizes) async {
    color.clear();
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("dress").doc(id).get();
    if (snapshot.exists) {
      setState(() {
        for (int i = 0; i < colors; i++) {
          color.add(snapshot["color${i + 1}"]);
        }
        for (int i = 0; i < sizes; i++) {
          size.add(snapshot["size${i + 1}"]);
        }
      });
    } else {
      setState(() {
        color.clear();
      });
    }
  }

  @override
  void dispose() {
    // Cancel the subscription to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Ugaaso",
                style: GoogleFonts.pacifico(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "App",
                style: GoogleFonts.pacifico(
                    color: Color.fromARGB(255, 243, 118, 109),
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("carts")
                      .doc(auth.currentUser!.uid)
                      .collection("carts")
                      .snapshots(),
                  builder: (context, snapshot) {
                    //if error occured
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Erorr Occured Sorry",
                          style: GoogleFonts.urbanist(
                              fontSize: 21,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    //if has data
                    else if (snapshot.hasData) {
                      List<QueryDocumentSnapshot> document =
                          snapshot.data!.docs;
                      total = 0.0;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Carts(document),
                            totalWidget(),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      );
                    } //else if
                    return Center(
                      child: Text(
                        "No Data",
                        style: GoogleFonts.urbanist(
                            fontSize: 21,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
            ],
          ),
        ),
        bottomNavigationBar: salmonFooterWidget(),
      ),
    );
  }

  Widget salmonFooterWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 98, 146, 229),
          borderRadius: BorderRadius.circular(25)),
      child: SalomonBottomBar(
        currentIndex: _currentBottom,
        onTap: (i) {
          setState(() {
            _currentBottom = i;
            if (_currentBottom == 0) {
              runApp(Home());
            } else if (_currentBottom == 1) {
              runApp(Cart());
            } else if (_currentBottom == 2) {
              runApp(Profilestle());
            }
          });
        },
        curve: Curves.easeInOut,
        items: [
          SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.home),
              title: const Text("Home"),
              selectedColor: const Color.fromARGB(255, 243, 118, 109),
              unselectedColor: Colors.white),
          SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.shopping_cart),
              title: const Text("Card"),
              selectedColor: const Color.fromARGB(255, 243, 118, 109),
              unselectedColor: Colors.white),
          SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.person),
              title: const Text("Profile"),
              selectedColor: const Color.fromARGB(255, 243, 118, 109),
              unselectedColor: Colors.white),
        ],
      ),
    );
  }

  //total
  Widget totalWidget() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white60, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          "Total",
          style: GoogleFonts.urbanist(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        subtitle: Text(
          "${total}\$",
          style: GoogleFonts.urbanist(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        trailing: Container(
          alignment: Alignment.center,
          width: 200,
          height: 60,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 243, 118, 109),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            "Buy Now",
            style: GoogleFonts.urbanist(
                fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  //Carts
  Widget Carts(List document) {
    return Column(
      children: List.generate(document.length, (int index) {
        count = document[index]
            ['count']; //to get count or number of dress user took
        int times = document[index]['price'] *
            document[index]['count']; //calculating total money
        total += times; //calculating total money

        return GestureDetector(
          onTap: () async {
            await getColor(document[index]["id"], document[index]["colors"],
                document[index]["sizes"]);
            setState(() {
              runApp(UpdateInside(
                  color: color,
                  sizes: document[index]["sizes"],
                  size: size,
                  dressId: document[index]['id'],
                  colors: document[index]['colors'],
                  title: document[index]['title'],
                  image: document[index]['url'],
                  price: document[index]['price'],
                  sizeIndex: document[index]['sizeIndex'],
                  colorIndex: document[index]['colorIndex'],
                  id: document[index].id));
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Cart
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 237, 237)),
                  child: Row(
                    children: [
                      //Image
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 245, 178, 173),
                            image: DecorationImage(
                                image: NetworkImage(document[index]['url']),
                                fit: BoxFit.fitHeight),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      //Title
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  document[index]['title'],
                                  style: GoogleFonts.urbanist(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 3),
                                ),
                              ),
                              Text(
                                "${document[index]['price']}\$",
                                style: GoogleFonts.urbanist(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    height: 4),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Size color and count
                      Column(
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //Color
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(document[index]["color"])),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          //Size
                          Container(
                            alignment: Alignment.center,
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Text(document[index]['size']),
                          ),

                          //Icons or count
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (count < 5) count++;
                                      updateCount(document[index].id);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 16,
                                  )),
                              Text(count.toString()),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (count > 1) count--;
                                      updateCount(document[index].id);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    size: 16,
                                  ))
                            ],
                          ),

                          //IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
