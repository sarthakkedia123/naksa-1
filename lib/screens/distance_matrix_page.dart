import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

String place_1 = "", place_2 = "", place_3 = "";

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Center(child: Text("")),
              Center(child: Text("")),
              Center(
                  child: Text("DISTANCE MATRIX",
                      style: TextStyle(color: Colors.white, fontSize: 40))),
              SizedBox(height: 25),
              Center(
                  child: Text("3 X 3",
                      style: TextStyle(color: Colors.white, fontSize: 30))),
              SizedBox(height: 30),
              Center(
                  child: Text("Enter Three Places",
                      style: TextStyle(color: Colors.white, fontSize: 30))),
              SizedBox(height: 30),
              Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Enter First Place",
                        hintStyle:
                            TextStyle(color: Colors.white54, fontSize: 20),
                        border: OutlineInputBorder(),
                        fillColor: Colors.green[800],
                        filled: true,
                        prefixIcon: Icon(Icons.location_city_sharp)),
                    onChanged: (String userinput) {
                      //User input ko store kar rahe hai
                      setState(() {
                        //User input ko store kar rahe hai
                        place_1 = userinput; //User input ko store kar rahe hai
                      }); //User input ko store kar rahe hai
                    }, //User input ko store kar rahe hai
                  )),
              SizedBox(height: 30),
              Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: "Enter Second Place",
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 20),
                          border: OutlineInputBorder(),
                          fillColor: Colors.green[800],
                          filled: true,
                          prefixIcon: Icon(Icons.location_city_sharp)),
                      onChanged: (String userinput) {
                        setState(() {
                          place_2 = userinput;
                        });
                      })),
              SizedBox(height: 30),
              Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Enter Third Place",
                        hintStyle:
                            TextStyle(color: Colors.white54, fontSize: 20),
                        border: OutlineInputBorder(),
                        fillColor: Colors.green[800],
                        filled: true,
                        prefixIcon: Icon(Icons.location_city_sharp)),
                    onChanged: (String userinput) {
                      setState(() {
                        place_3 = userinput;
                      });
                    },
                  )),
              SizedBox(height: 80),
              //Center(child:Text("Hare Krishna $place_1",style: TextStyle(color: Colors.lime))),
              MyHomePage()
            ],
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 50,
      child: RaisedButton(
          color: Colors.blue[900],
          child: Text("Calculate", style: TextStyle(color: Colors.white)),
          onPressed: () {
            bookFlight(context);
          }),
    );
  }

  void bookFlight(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Matrix"),
      content: Column(children: [
        Center(child: Text("A:$place_1", style: TextStyle(fontSize: 20))),
        Center(child: Text("B:$place_2", style: TextStyle(fontSize: 20))),
        Center(child: Text("C:$place_3", style: TextStyle(fontSize: 20))),
        SizedBox(height: 30),
      ]),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}

