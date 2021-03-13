import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naksa/constants/constant_colors.dart';
import 'package:naksa/screens/distance_matrix_page.dart';
import 'package:naksa/screens/map.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {

  _showFormInDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: bodyBlackColor,
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'CLOSE',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ],
            title: Text(
              'DEVELOPERS',
              style: GoogleFonts.rubik(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Mr. X',
                    style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Text(
                    'Mr. Y',
                    style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Text(
                    'Mr. Z',
                    style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bodyWhiteColor,
      width: 250,
      child: Drawer(
        child: Container(
          color: bodyBlackColor,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: RichText(
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
              Divider(
                thickness: .5,
                indent: 15,
                endIndent: 30,
                color: bodyWhiteColor,
              ),
              ListTile(
                title: Text(
                  'Institute Map',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: bodyWhiteColor,
                    ),
                  ),
                ),
                leading: Icon(
                  Icons.map,
                  color: bodyWhiteColor,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MapPage()));
                },
              ),
              ListTile(
                title: Text(
                  'Distance Matrix',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: bodyWhiteColor,
                    ),
                  ),
                ),
                leading: Icon(
                  Icons.directions,
                  color: bodyWhiteColor,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DistanceMatrixPage()));
                },
              ),
              ListTile(
                title: Text(
                  'About Us',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: bodyWhiteColor,
                    ),
                  ),
                ),
                leading: Icon(
                  Icons.info,
                  color: bodyWhiteColor,
                ),
                onTap: () {
                  _showFormInDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
