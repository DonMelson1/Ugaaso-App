import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion/LogIn.dart';
import 'package:fashion/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SignUpstaful());
  }
}

class SignUpstaful extends StatefulWidget {
  const SignUpstaful({super.key});

  @override
  State<SignUpstaful> createState() => _SignUpstafulState();
}

class _SignUpstafulState extends State<SignUpstaful> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController confpassword = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  //Sign Up
  Future<void> signUp() async {
    if (email.text != "" &&
        name.text != "" &&
        password.text != "" &&
        confpassword.text != "") {
      if (password.text == confpassword.text) {
        if (name.text.length < 13) {
          try {
            await auth.createUserWithEmailAndPassword(
                email: email.text, password: password.text);
            String id = auth.currentUser!.uid;

            //create collection firestore
            await FirebaseFirestore.instance
                .collection("users")
                .doc(id)
                .set({"name": name.text, "email": email.text});

            runApp(SignIn());
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
                  message =
                      "An unexpected error occurred. Please try again later.";
              }
            } else {
              message = "An unexpected error occurred. Please try again later.";
            }
            dialog.showAlertDialog(context, title: title, message: message);
          }
        }
        else{
          dialog.showAlertDialog(context,
            title: "Warning",
            message: "Name Length is too much please short it");
        }
      } else {
        dialog.showAlertDialog(context,
            title: "Warning",
            message: "Password and Confirm-Password isn't same");
      }
    } else {
      dialog.showAlertDialog(context,
          title: "Warning", message: "You Must fill all the blanks");
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
            padding: const EdgeInsets.only(top: 80.0),
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
                          child: Text(
                            "SIGN UP",
                            style: GoogleFonts.urbanist(
                                textStyle: TextStyle(
                                    color: Color.fromARGB(255, 243, 118, 109),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                          ),
                        ),
                    
                        SizedBox(
                          height: 15,
                        ),
                    
                        textfield(name, false, "Enter Surname", false),
                    
                        textfield(email, false, "Enter Email", false),
                    
                        textfield(password, true, "Enter Password", isVisible),
                    
                        textfield(confpassword, true, "Enter Confrim Password",
                            isVisible),
                    
                        SizedBox(
                          height: 40,
                        ),
                    
                        //Button
                        Container(
                          width: 380,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: signUp,
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent),
                          ),
                        ),
                    
                        SizedBox(
                          height: 20,
                        ),
                    
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "have an account",
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19)),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  runApp(SignIn());
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.urbanist(
                                      textStyle: TextStyle(
                                          color: Color.fromARGB(255, 243, 118, 109),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23)),
                                ),
                              ),
                            ),
                          ],
                        ),
                    
                        SizedBox(
                          height: 30,
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

  Widget textfield(TextEditingController controller, bool hasSuffic,
      String hintText, bool visible) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                textStyle: TextStyle(
                    fontSize: 19,
                    color: const Color.fromARGB(255, 75, 74, 74))),
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
                hintText: hintText,
                hintStyle: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 19,
                        color: const Color.fromARGB(255, 75, 74, 74))),
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
