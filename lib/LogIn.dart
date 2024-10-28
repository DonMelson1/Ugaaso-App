import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion/Home.dart';
import 'package:fashion/SignUp.dart';
import 'package:fashion/Start_Page.dart';
import 'package:fashion/dialog.dart';
import 'package:fashion/main.dart';
import 'package:fashion/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SignInsteful());
  }
}

class SignInsteful extends StatefulWidget {
  const SignInsteful({super.key});

  @override
  State<SignInsteful> createState() => _SignInstefulState();
}

class _SignInstefulState extends State<SignInsteful> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  //Sign In Method
  Future<void> signin() async {
    if (email.text != "" && password.text != "") {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        runApp(Home());
      } catch (error) {
        String title = "Sign In Error";
        String message = "";

        if (error is FirebaseAuthException) {
          switch (error.code) {
            case 'invalid-email':
              message =
                  "The email address you entered is not valid. Please check and try again.";
              break;
            case 'network-request-failed':
              message =
                  "Network error detected. Please check your internet connection and try again.";
              break;
            case 'user-not-found':
              message =
                  "No account found with the given email. Would you like to create a new account?";
              break;
            case 'wrong-password':
              message =
                  "The password entered is incorrect. Please try again or reset your password.";
              break;
            case 'email-already-in-use':
              message =
                  "This email address is already associated with an existing account. Please use a different email or log in.";
              break;
            default:
              message = "An unexpected error occurred. Please try again later.";
          }
        } else {
          message = "An unexpected error occurred. Please try again later.";
        }
        dialog.showAlertDialog(context, title: title, message: message);
      }
    } else {
      dialog.showAlertDialog(context,
          title: "Warning", message: "Enter Email and Password");
      
    }
  }

  //Google Sign-In
  Future<void> googlesign() async {
    try {
      GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
      if (_googleUser == null) {
        // Sign-in process was aborted (user may have cancelled)
        return;
      }

      GoogleSignInAuthentication? _googleAuth =
          await _googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _googleAuth?.accessToken,
        idToken: _googleAuth?.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      String id = userCredential.user!.uid;
      //create collection firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .set({"name": "UnKnown", "email": userCredential.user!.email});
      runApp(Profile());
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
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
                    color: Colors.white,
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
          backgroundColor: Colors.blueAccent,
        ),
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Opacity(
              opacity: 0.7,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        //Spacer(),

                        //SignIn
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                          child: Text("SIGN IN",
                              style: GoogleFonts.urbanist(
                                  color: Color.fromARGB(255, 243, 118, 109),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25)),
                        ),

                        SizedBox(
                          height: 30,
                        ),

                        textfield(email, false, false),

                        textfield(password, true, isVisible),

                        SizedBox(
                          height: 30,
                        ),

                        //Button
                        Container(
                          width: 380,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: signin,
                            child: Text(
                              "Sign In",
                              style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        //dont have account
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Don't have an account",
                                style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19)),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  runApp(SignUp());
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text("Sign Up",
                                    style: GoogleFonts.urbanist(
                                        color:
                                            Color.fromARGB(255, 243, 118, 109),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23)),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        //Sign With Google
                        Container(
                          width: 380,
                          height: 55,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(30)),
                          child: ElevatedButton.icon(
                            onPressed: googlesign,
                            icon: Image.asset(
                              'Images/google_icon.png', // Path to your Google logo asset
                              height:
                                  24, // Adjust the size of the icon as needed
                            ),
                            label: Text(
                              "Sign In with Google",
                              style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textfield(
      TextEditingController controller, bool hasSuffic, bool visible) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Container(
        width: 390,
        height: 55,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            controller: controller,
            obscureText: visible,
            cursorColor: Colors.grey,
            style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 100, 98, 98), fontSize: 19),
            decoration: InputDecoration(
                suffix: hasSuffic == true
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? Icon(CupertinoIcons.eye_slash_fill)
                            : Icon(CupertinoIcons.eye_fill))
                    : null,
                hintText: "Enter Email",
                hintStyle: GoogleFonts.lato(
                    color: const Color.fromARGB(255, 122, 121, 121),
                    fontSize: 19),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ))),
          ),
        ),
      ),
    );
  }
}
