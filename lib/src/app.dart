import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naksa/screens/home_screen.dart';
Map<int, Color> color =
{
  50:Color.fromRGBO(57,62,70,1),
  100:Color.fromRGBO(57,62,70,1),
  200:Color.fromRGBO(57,62,70,1),
  300:Color.fromRGBO(57,62,70,1),
  400:Color.fromRGBO(57,62,70,1),
  500:Color.fromRGBO(57,62,70,1),
  600:Color.fromRGBO(57,62,70,1),
  700:Color.fromRGBO(57,62,70,1),
  800:Color.fromRGBO(57,62,70,1),
  900:Color.fromRGBO(57,62,70,1),
};
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xff393e46,color);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: HomeScreen(),
    );
  }
}
