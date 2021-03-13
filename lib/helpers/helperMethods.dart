

import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naksa/constants/global_variables.dart';
import 'package:naksa/data_models/address.dart';
import 'package:naksa/data_models/directionDetails.dart';
import 'package:naksa/data_provider/appdata.dart';
import 'package:naksa/helpers/requestHelper.dart';
import 'package:provider/provider.dart';

class HelperMethods
{
  static Future<String> findAddressByCoordinates(Position position , context) async{
      String placeAddress ='';
      var connectivityChecker = await Connectivity().checkConnectivity();
      if(connectivityChecker != ConnectivityResult.mobile && connectivityChecker != ConnectivityResult.wifi)
        {
          return placeAddress;
        }
      String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapApiKey';

      var response = await RequestHelper.getRequest(url);

      if(response != 'failed')
        {
          placeAddress = response['results'][0]['formatted_address'];
          Address originAddress = new Address();

          originAddress.latitude = position.latitude;
          originAddress.longitude = position.longitude;
          originAddress.placeName = placeAddress;

          Provider.of<AppData>(context, listen:  false).updateOriginAddress(originAddress);
        }
      return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapApiKey';
    var response = await RequestHelper.getRequest(url);

    if(response == 'failed')
      {
        return null;
      }
    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];

    return directionDetails;

  }
}