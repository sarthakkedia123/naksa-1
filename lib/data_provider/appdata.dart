
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naksa/data_models/address.dart';

class AppData extends ChangeNotifier
{
  Address originAddress;
  Address destinationAddress;

  void updateOriginAddress(Address origin)
  {
    originAddress = origin;
    notifyListeners();
  }

  void updateDestinationAddress( Address destination)
  {
    destinationAddress = destination;
    notifyListeners();
  }

}