import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle title = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle body = GoogleFonts.poppins(fontSize: 16);

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 13,
    color: Colors.grey,
  );
}
