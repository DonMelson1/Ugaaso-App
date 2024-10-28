import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class dialog {

  static void showAlertDialog(BuildContext context, {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 22, color: Colors.red)),
          ),
          content: Text(
            message,
            style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 18, color: Colors.grey)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
          ],
        );
      },
    );
  }


 
}
