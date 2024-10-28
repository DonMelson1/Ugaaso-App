import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion/Home.dart';
import 'package:fashion/LogIn.dart';
import 'package:fashion/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:preload_page_view/preload_page_view.dart';

class Start_Page extends StatefulWidget {
  const Start_Page({super.key});

  @override
  State<Start_Page> createState() => _Start_PageState();
}

class _Start_PageState extends State<Start_Page> {
  List<String> images = ["Images/woman_fashion.jpg","Images/gorgeousWoman.jpg","Images/hotWoman.jpg","Images/youngWoman.jpg"];
  PreloadPageController _pageController = PreloadPageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PreloadPageView.builder(
          controller: _pageController,
          itemCount: 2, // Three pages
          preloadPagesCount: 2, // Preload the next two pages
          itemBuilder: (context, index) {
            // Last page has "Start" button, others have "Next"
            if (index == 1) {
              return buildPage(
                url: images[index],
                buttonText: "Start",
                onPressed: () {
                  // Do something when "Start" is pressed (e.g., navigate to home screen)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                },
              );
            } else {
              return buildPage(
                url: images[index],
                buttonText: "Next",
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildPage(
      {required String url,
      required String buttonText,
      required VoidCallback onPressed}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover)),
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('THE CHIC',
                      style: GoogleFonts.exo2(
                          textStyle: const TextStyle(
                              fontSize: 30, color: Colors.white60))),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('UGAASO',
                      style: GoogleFonts.lobster
                      (
                          textStyle: const TextStyle(
                              fontSize: 30, color: Colors.white70))),
                      SizedBox(width: 10,),
                      Text('COLLECTION',
                      style: GoogleFonts.lobster(
                          textStyle: const TextStyle(
                              fontSize: 30, color: Colors.blueAccent))),
                              
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    child: Text(buttonText,
                        style: GoogleFonts.exo2(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(153, 18, 16, 16)))),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
