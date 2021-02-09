import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naksa/screens/map.dart';
import 'package:naksa/screens/home_screen.dart';

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
            backgroundColor: Color(0xff393e46),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
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
      color: Colors.transparent,
      child: Drawer(
        child: Container(
          color: Color(0xff393e46),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  'USER NAME',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                accountEmail: Text(
                  'tempmail@gmail.com',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Color(0xffffffff),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: .5,
                indent: 15,
                endIndent: 30,
                color: Color(0xffffffff),
              ),
              ListTile(
                title: Text(
                  'Institute Map',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                leading: Icon(
                  Icons.map,
                  color: Color(0xffffffff),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Map()));
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
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                leading: Icon(
                  Icons.info,
                  color: Color(0xffffffff),
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
