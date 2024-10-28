import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion/Home.dart';
import 'package:fashion/Start_Page.dart';
import 'package:fashion/cart.dart';
import 'package:fashion/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:path/path.dart' as path;

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Profilestle());
  }
}

class Profilestle extends StatefulWidget {
  const Profilestle({super.key});

  @override
  State<Profilestle> createState() => _ProfilestleState();
}

class _ProfilestleState extends State<Profilestle> {
  int _currentBottom = 2;
  String name = "Loading....";
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  String? _image;

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

  //ImagePicker
  Future<void> imagePicker() async {
    ImagePicker picker = ImagePicker();
    XFile? _xfile = await picker.pickImage(source: ImageSource.gallery);
    if (_xfile != null) {
      setState(() {
        File _image = File(_xfile.path);
        uploadImage(_image);
      });
    }
  }

  //upload Image
  Future<void> uploadImage(File image) async {
    try {
      String? id = auth.currentUser?.email;
      String extension = path.extension(image.path);
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + extension;
      Reference ref = storage.ref().child("profile/$id/$fileName");
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      await FirebaseFirestore.instance
          .collection("profile")
          .doc(auth.currentUser?.email)
          .set({
        "url": downloadUrl,
      });
      getImage();
    } catch (e) {
      print(e);
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
        body: ListView(
          children: [
            Column(
              children: [
                //prifile
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _image == null
                              ? AssetImage(
                                  "Images/gorgeousWoman.jpg",
                                )
                              : NetworkImage(_image!),
                          fit: BoxFit.cover)),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        bottom: 8,
                        right: 2,
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent, shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: imagePicker,
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                ),

                //name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Icon(
                        Icons.person_2_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      "Name",
                      style: GoogleFonts.urbanist(
                          color: Colors.grey, fontSize: 12, height: 1),
                    ),
                    subtitle: Text(
                      name,
                      style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: IconButton(
                          onPressed: () {
                            
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          )),
                    ),
                  ),
                ),

                //Gmail
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      "Email",
                      style: GoogleFonts.urbanist(
                          color: Colors.grey, fontSize: 12, height: 1),
                    ),
                    subtitle: Text(
                      "${FirebaseAuth.instance.currentUser!.email}",
                      style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Icon(
                        Icons.password,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      "Password",
                      style: GoogleFonts.urbanist(
                          color: Colors.grey, fontSize: 12, height: 1),
                    ),
                    subtitle: Text(
                      "Change Password",
                      style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          )),
                    ),
                  ),
                ),

                //logout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        auth.signOut();
                        runApp(Start_Page());
                      });
                    },
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Icon(
                        CupertinoIcons.return_icon,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: salmonFooterWidget(),
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
              runApp(Profile());
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
}
