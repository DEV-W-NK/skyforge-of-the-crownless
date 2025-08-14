// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portifolio/Pages/home_page.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';


void main() {
  runApp(SkyforgeApp());
}

class SkyforgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skyforge of the Crownless',
      theme: CyberpunkTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(CyberpunkTheme.darkTheme.textTheme),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
