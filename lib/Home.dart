import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion/Inside.dart';
import 'package:fashion/LogIn.dart';
import 'package:fashion/Start_Page.dart';
import 'package:fashion/cart.dart';
import 'package:fashion/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String name = "loading...";
  String? _image;
  int _currentCategory = 0;
  int _currentBottom = 0;
  List Categories = ["All", "Fashion Dress", "T-Shirt", "Night Dress"];

  getonlineData() {
    if (_currentCategory == 1) {
      return onlineDataWidget("fashion");
    } else if (_currentCategory == 2) {
      return onlineDataWidget('t-shirt');
    } else if (_currentCategory == 3) {
      return onlineDataWidget('night');
    } else {
      return onlineDataWidget('all');
    }
  }

  //geting the username if he has
  Future<void> getName() async {
    try {
      String id = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("users").doc(id).get();

      if (snapshot.exists) {
        setState(() {
          name = snapshot['name'].toString();
        });
      } else {
        setState(() {
          name = "unknown";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        name = "unknown"; // Set to a default value in case of an error
      });
    }
  }

  //Geting Profile Image
  Future<void> getImage() async {
    try {
      String? id = FirebaseAuth.instance.currentUser!.email;
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("profile").doc(id).get();

      if (snapshot.exists) {
        setState(() {
          _image = snapshot['url'].toString();
        });
      } else {
        setState(() {
          _image = "";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        _image = ""; // Set to a default value in case of an error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getName();
    getImage();
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
        body: ListView(
          children: [
            Column(
              children: [
                //header
                headerWidget(),

                //search button
                searchFieldWidget(),

                //Container advertise
                bigSaleWidget(),

                //categories
                categoriesWidget(),

                //online data or dresses
                getonlineData(),
              ],
            ),
          ],
        ),
        bottomNavigationBar: salmonFooterWidget(),
      ),
    );
  }

  Widget searchFieldWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 370,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              style: GoogleFonts.lato(
                textStyle: const TextStyle(color: Colors.grey, height: 2),
              ),
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: GoogleFonts.lato(
                    textStyle: const TextStyle(color: Colors.grey),
                  ),
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ))),
            ),
          ),
        ),
      ],
    );
  }

  //header Widget
  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Icon App Name
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Ugaaso",
                  style: GoogleFonts.pacifico(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "App",
                  style: GoogleFonts.pacifico(
                      color: Color.fromARGB(255, 243, 118, 109),
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
              ],
            ),

            //Title or name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  Text("${name}",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.black87, fontSize: 20),
                      )),
                  Text(auth.currentUser!.email.toString(),
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Color.fromARGB(221, 163, 157, 157),
                            fontSize: 17),
                      )),
                ],
              ),
            ),

            //Icon Button image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Color.fromARGB(179, 241, 190, 190),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _image == null
                          ? AssetImage("Images/gorgeousWoman.jpg")
                          : NetworkImage(_image!),
                      fit: BoxFit.cover)),
            ),
          ],
        ),
      ),
    );
  }

  //Container advertise
  Widget bigSaleWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        alignment: Alignment.centerLeft,
        width: 370,
        height: 200,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 118, 109),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior:
              Clip.none, // Allow the image to go outside the container
          children: [
            // Positioned image
            Positioned(
              top: -30,
              left: -60,
              child: Image.asset(
                "Images/BigSale.png",
                width: 345,
              ),
            ),

            Row(
              children: [
                const Spacer(), //spacing between the image and the text

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Big Sale",
                          style: GoogleFonts.pacifico(
                            textStyle: const TextStyle(
                                color: Colors.white70,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                height: 2),
                          )),
                      Text(
                          "Call the company \nThere is big Offer \nWelcome man",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Footer
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

  //online data or dresses
  Widget onlineDataWidget(String type) {
    return StreamBuilder<QuerySnapshot>(
      stream: type == 'all'
          ? FirebaseFirestore.instance.collection('dress').snapshots()
          : FirebaseFirestore.instance
              .collection('dress')
              .where('type', isEqualTo: type)
              .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Check if the data is still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // If there is an error
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // If data is available
        if (snapshot.hasData) {
          // Get the documents from the snapshot
          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 0,
                    childAspectRatio: 0.47),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      //to get colors and to get that using colors to now number of colors
                      int colors = documents[index]['colors'];
                      List<int> color = [];
                      for (int i = 0; i < colors; i++) {
                        color.add(documents[index]['color${i + 1}']);
                      }

                      //to get size1 or 2 and to that using sizes to now number of sizes that coloth has
                      int sizes = documents[index]['sizes'];
                      List<String> size = [];
                      for (int i = 0; i < sizes; i++) {
                        size.add(documents[index]['size${i + 1}']);
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Inside(
                                  sizes: sizes,
                                  size: size,
                                  color: color,
                                  colors: colors,
                                  id: documents[index].id,
                                  title: documents[index]['title'],
                                  image: documents[index]['url'],
                                  price: documents[index]['price'])));
                    },
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(documents[index]['url']),
                                fit: BoxFit.cover),
                            color: const Color.fromARGB(255, 245, 178, 173),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            documents[index]['title'],
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 17),
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${documents[index]['price']}\$",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 17),
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        }

        // Default return if no data
        return Center(
          child: Text('No images found'),
        );
      },
    );
  }

  //categories
  Widget categoriesWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: ListView.builder(
            itemCount: Categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentCategory = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 30,
                      decoration: BoxDecoration(
                          color: _currentCategory != index
                              ? Colors.grey
                              : Color.fromARGB(255, 243, 118, 109),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "${Categories[index]}",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.white70, fontSize: 17)),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
