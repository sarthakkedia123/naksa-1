import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naksa/constants/constant_colors.dart';
import 'package:naksa/supporter/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'na',
              style: GoogleFonts.rubik(
                textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: bodyWhiteColor,
                ),
              ),
            ),
            TextSpan(
              text: 'Ksa',
              style: GoogleFonts.rubik(
                textStyle: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: bodyWhiteColor,
                ),
              ),
            ),
          ]),
        ),
      ),
    drawer: DrawerNavigation(),
    body: Container(
      decoration: BoxDecoration(
        color: Color(0xff393e46),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/map.png'
          ),
          fit: BoxFit.contain,
        ),
      ),
    ),
    );
  }
}
