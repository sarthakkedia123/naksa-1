import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naksa/constants/constant_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naksa/data_models/directionDetails.dart';
import 'package:naksa/data_provider/appdata.dart';
import 'package:naksa/helpers/helperMethods.dart';
import 'package:naksa/screens/search_places_page.dart';
import 'package:naksa/supporter/drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(),
      body: AddressNavigation(),
    );
  }
}

class AddressNavigation extends StatefulWidget {
  @override
  _AddressNavigationState createState() => _AddressNavigationState();
}

class _AddressNavigationState extends State<AddressNavigation> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Geolocator _geolocator = Geolocator();

  // Completer
  Completer<GoogleMapController> mapController = Completer();
  GoogleMapController homeMapController;

  // Home Map controller

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  DirectionDetails tripDirectionDetails;
  void _onHomeMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
    homeMapController = controller;

    // as soon as current location is fetched get the new updated map
    setUpCurrentPosition();
  }

  Position currentPosition;

  void setUpCurrentPosition() async {
    Position position = await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(
      target: pos,
      zoom: 14,
    );
    homeMapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address =
        await HelperMethods.findAddressByCoordinates(position, context);
    print(address);
  }

// function to show initial camera position

  CameraPosition _initialCameraPosition() {
    return CameraPosition(
      target: LatLng(25.267878, 82.990494),
      zoom: 14,
      bearing: 0.0,
      tilt: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      backgroundColor: bodyBlackColor,
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bodyBlackColor,
        child: Icon(
          Icons.directions,
          color: bodyWhiteColor,
          size: 40,
        ),
        onPressed: () async {
          var response = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchPlacesPage()));

          if (response == 'getDirection') {
            await getDirection();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onHomeMapCreated,
            initialCameraPosition: _initialCameraPosition(),
            polylines: _polylines,
            markers: _markers,
            circles: _circles,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
          ),
          Positioned(
            top: 10,
            left: 18,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: bodyBlackColor,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: bodyBlackColor,
                        spreadRadius: .5,
                        blurRadius: 5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ]),
                child: CircleAvatar(
                  backgroundColor: bodyBlackColor,
                  radius: 22,
                  child: Icon(
                    Icons.menu,
                    color: bodyWhiteColor,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width*.5 -100,
            top: 10,
            child: Container(
              width: MediaQuery.of(context).size.width*.5,
              height: 40,
              color: bodyWhiteColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'DIST. : ',
                          style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: bodyBlackColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          (tripDirectionDetails != null)?
                          tripDirectionDetails.distanceText : '',
                          style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: bodyBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'DURA. : ',
                          style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: bodyBlackColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          (tripDirectionDetails != null)?
                          tripDirectionDetails.durationText: '',
                          style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: bodyBlackColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> getDirection() async {
    var startLocation =
        Provider.of<AppData>(context, listen: false).originAddress;
    var endLocation =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var startLocationLatLng =
        LatLng(startLocation.latitude, startLocation.longitude);
    var endLocationLatLng = LatLng(endLocation.latitude, endLocation.longitude);

    var thisDetails = await HelperMethods.getDirectionDetails(
        startLocationLatLng, endLocationLatLng);

    setState(() {
      tripDirectionDetails = thisDetails;
    });

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);
    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      //loop through all pointLatLng points and convert them to a list of LatLng, required by the Polyline
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });

    LatLngBounds bounds;
    if (startLocationLatLng.latitude > endLocationLatLng.latitude &&
        startLocationLatLng.longitude > endLocationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: endLocationLatLng, northeast: startLocationLatLng);
    } else if (startLocationLatLng.longitude > endLocationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest:
              LatLng(startLocationLatLng.latitude, endLocationLatLng.longitude),
          northeast: LatLng(
              endLocationLatLng.latitude, startLocationLatLng.longitude));
    } else if (startLocationLatLng.latitude > endLocationLatLng.latitude) {
      bounds = LatLngBounds(
          southwest:
              LatLng(endLocationLatLng.latitude, startLocationLatLng.longitude),
          northeast: LatLng(
              startLocationLatLng.latitude, endLocationLatLng.longitude));
    } else {
      bounds = LatLngBounds(
          southwest: startLocationLatLng, northeast: endLocationLatLng);
    }
    homeMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker startMarker = Marker(
      markerId: MarkerId('origin'),
      position: startLocationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow:
          InfoWindow(title: startLocation.placeName, snippet: 'My Location'),
    );

    Marker endMarker = Marker(
      markerId: MarkerId('destination'),
      position: endLocationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: endLocation.placeName, snippet: 'Destination'),
    );

    setState(() {
      _markers.add(startMarker);
      _markers.add(endMarker);
    });

    Circle startCircle = Circle(
        circleId: CircleId('origin'),
        strokeColor: Colors.green,
        strokeWidth: 3,
        radius: 12,
        center: startLocationLatLng,
        fillColor: Colors.green);
    Circle endCircle = Circle(
        circleId: CircleId('destination'),
        strokeColor: Colors.red,
        strokeWidth: 3,
        radius: 12,
        center: endLocationLatLng,
        fillColor: Colors.red);

    setState(() {
      _circles.add(startCircle);
      _circles.add(endCircle);
    });
  }
}
