import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naksa/constants/constant_colors.dart';
import 'package:naksa/supporter/drawer.dart';

int timesCalled = 0;
//TODO ENTER YOUR OWN GOOGLE MAP API KEY TO RUN THE MAP IN YOUR DEVICE
// ignore: must_be_immutable
// stateless widget of Map screen that take arguments
// ignore: must_be_immutable
class MapPage extends StatelessWidget {
  bool _createWorkshop = false;
  bool _workshopDetails = false;
  String _workshopLatitude = '';
  String _workshopLongitude = '';

  @override

  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      _createWorkshop = arguments['fromWorkshopCreate'] ?? false;
      _workshopDetails = arguments['fromWorkshopDetails'] ?? false;
      if (_workshopDetails) {
        _workshopLatitude = arguments['latitude'];
        _workshopLongitude = arguments['longitude'];
      }
    }
//returning a location screen stateful widget
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        drawer: DrawerNavigation(),
        body: LocationScreen(
          _createWorkshop,
          _workshopDetails,
          _workshopLatitude,
          _workshopLongitude,
        ),
      ),
    );
  }
}
// what unique key do? it creates a key that is equal only to itself.
class LocationScreen extends StatefulWidget {
  final Key _mapKey = UniqueKey();
  final bool createWorkshop;
  final bool workshopDetails;
  final String workshopLatitude;
  final String workshopLongitude;

  LocationScreen(
    this.createWorkshop,
    this.workshopDetails,
    this.workshopLatitude,
    this.workshopLongitude,
  ) : super();

  @override
  _LocationScreenState createState() => _LocationScreenState();
}
//calling OurMap stateful class
class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return OurMap(
      key: widget._mapKey,
      createWorkshop: widget.createWorkshop,
      workshopDetails: widget.workshopDetails,
      workshopLatitude: widget.workshopLatitude,
      workshopLongitude: widget.workshopLongitude,
    );
  }
}

class OurMap extends StatefulWidget {
  final bool createWorkshop;
  final bool workshopDetails;
  final String workshopLatitude;
  final String workshopLongitude;

  //to avoid crush at hot reload a key is required
  OurMap({
    @required Key key,
    this.createWorkshop,
    this.workshopDetails,
    this.workshopLatitude,
    this.workshopLongitude,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<OurMap> {
  Color color = Colors.greenAccent;
  //map controller
  Completer<GoogleMapController> mapController = Completer();
  //List of markers
  List<Marker> _hostelMarkers = <Marker>[];
  List<Marker> _departmentMarkers = <Marker>[];
  List<Marker> _lectureHallMarkers = <Marker>[];
  List<Marker> _otherMarkers = <Marker>[];
  List<Marker> _allMarkers = <Marker>[];
  List<Marker> _displayMarkers = <Marker>[];

  bool _selectedList = false;
// initial map position
  CameraPosition _initialCameraPosition(
      [String workshopLatitude = '', String workshopLongitude = '']) {
    print(workshopLatitude);
    return workshopLatitude == ''
        ? CameraPosition(
            target: LatLng(25.267878, 82.990494),
            zoom: 15,
            bearing: 0.0,
            tilt: 0.0,
          )
        : CameraPosition(
            target: LatLng(double.parse(workshopLatitude),
                double.parse(workshopLongitude)),
            zoom: 15,
            tilt: 75,
            bearing: Random().nextDouble() * 90);
  }

  moveCameraToMarker(Map coord) async {
    final GoogleMapController controller = await mapController.future;
    final _camera = CameraPosition(
      target: LatLng(coord['LatLng'].latitude, coord['LatLng'].longitude),
      zoom: 15,
      tilt: 75,
      bearing: Random().nextDouble() * 90,
    );
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_camera),
    );
  }

  simpleMoveCameraToMarker(String latitude, String longitude) async {
    print('moving to ($latitude, $longitude)');
    final GoogleMapController controller = await mapController.future;
    final _camera = CameraPosition(
      target: LatLng(double.parse(latitude), double.parse(longitude)),
      zoom: 15,
      tilt: 75,
      bearing: Random().nextDouble() * 90,
    );
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_camera),
    );
  }

  Marker _getMarker({String category, var coord, int i, double hue}) {
    return Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      markerId: MarkerId('category ${i.toString()}'),
      position: LatLng(coord['LatLng'].latitude, coord['LatLng'].longitude),
      infoWindow: InfoWindow(
        title: coord['title'],
      ),
      onTap: () => moveCameraToMarker(coord),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    color = bodyBlackColor;
    int i = 0;
    for (var coord in coords['Hostels']) {
      i += 1;
      Marker newMarker = _getMarker(
          category: 'Hostel', coord: coord, i: i, hue: BitmapDescriptor.hueBlue);
      this._hostelMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }
    i = 0;
    for (var coord in coords['Departments']) {
      i += 1;
      Marker newMarker = _getMarker(
          category: 'Department',
          coord: coord,
          i: i,
          hue: BitmapDescriptor.hueRose);

      this._departmentMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }
    i = 0;

    for (var coord in coords['Lecture Halls']) {
      i += 1;
      Marker newMarker = _getMarker(
          category: 'LT', coord: coord, i: i, hue: BitmapDescriptor.hueCyan);

      this._lectureHallMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }

    i = 0;
    for (var coord in coords['Others']) {
      i += 1;
      Marker newMarker = _getMarker(
          category: 'Other',
          coord: coord,
          i: i,
          hue: BitmapDescriptor.hueYellow);

      this._otherMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }
    _displayMarkers.addAll(_allMarkers);

    if (mounted)
      setState(() {
        print(_displayMarkers.length);
        if (widget.createWorkshop && timesCalled == 0) {
          _settingModalBottomSheet(context);
          timesCalled += 1;
        }
      });
  }

  void _settingModalBottomSheet(context) {
    final container = (String title, Function setDisplayMarker) => Container(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bodyBlackColor,
          ),
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              if (this.mounted)
                setState(() {
                  _selectedList = true;
                  setDisplayMarker();
                });
            },
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: bodyBlackColor
          ),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  container('Hostels', () => {_displayMarkers = _hostelMarkers}),
                  container(
                      'Departments', () => {_displayMarkers = _departmentMarkers}),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  container('Lecture Halls', () => {_displayMarkers = _lectureHallMarkers}),
                  container('Others', () => {_displayMarkers = _otherMarkers}),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> locationSetDialog(
      BuildContext context, String title, String innerText) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? '(No Title)'),
            content: Text(innerText ?? '(No Inner Text)'),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  return false;
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timesCalled = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBlackColor,
      appBar: AppBar(
        backgroundColor: bodyBlackColor,
        title: Text(
          (widget.createWorkshop ? 'Workshop Location-' : '') +
              'IIT BHU MAP',
          style: GoogleFonts.rubik(
            textStyle: TextStyle(
              fontSize: 18,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              color: bodyWhiteColor,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bodyBlackColor,
        child: Icon(Icons.menu_sharp, color: Colors.white, size: 30),
        onPressed: () {
          _settingModalBottomSheet(context);
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: widget.workshopDetails
                ? _initialCameraPosition(
                    widget.workshopLatitude, widget.workshopLongitude)
                : _initialCameraPosition(),
            mapType: MapType.normal,
            mapToolbarEnabled: true,
            markers: Set.from(_displayMarkers),
            onTap: (tappedPosition) {
              print(
                  'latitude : ${tappedPosition.latitude}      longitude: ${tappedPosition.longitude}');
            },
          ),
          _selectedList
              ? Positioned(
            right: 2,
            top: 56,
            child: InkWell(
              onTap: () async {
                setState(() {
                  _selectedList = false;
                  _displayMarkers = _allMarkers;
                });

                final GoogleMapController controller =
                await mapController.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    _initialCameraPosition()));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: buttonColor),
                child: Text(
                  'Close',
                  style: TextStyle(color: bodyWhiteColor),
                ),
              ),
            ),
          )
              : Container(),
          _selectedList
              ? Positioned(
                  top: 5,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: bodyBlackColor,
                    ),
                    height: 40,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _displayMarkers.length,
                        itemBuilder: (context, index) {
                          Marker _tappableMarker = _displayMarkers[index];
                          List<Text> textList = [];

                          for (var text
                              in _tappableMarker.infoWindow.title.split(' ')) {
                            textList.add(Text(text,
                                style: TextStyle(color: bodyWhiteColor)));
                          }

                          return InkWell(
                            onTap: () async {
                              final GoogleMapController controller =
                                  await mapController.future;
                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: _tappableMarker.position,
                                    zoom: 18,
                                    tilt: 75.0,
                                    bearing: Random().nextDouble() * 90,
                                  ),
                                ),
                              );
                              if (widget.createWorkshop) {
                                print(_displayMarkers[index]);
                                bool shouldLocationBeSet = await locationSetDialog(
                                    context,
                                    'Location Set',
                                    'Do you want to set ${_displayMarkers[index].infoWindow.title} as the location for the workshop/event?');
                                if (shouldLocationBeSet == true) {
                                  Navigator.pop(context, [
                                    _displayMarkers[index]
                                        .position
                                        .latitude
                                        .toStringAsFixed(6),
                                    _displayMarkers[index]
                                        .position
                                        .longitude
                                        .toStringAsFixed(6),
                                    _displayMarkers[index]
                                        .infoWindow
                                        .title
                                        .toString(),
                                  ]);
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 6, 8, 6),
                              padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                              decoration: BoxDecoration(
                                color: bodyBlackColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _tappableMarker.infoWindow.title,
                                style: TextStyle(color: Colors.white)
                                //  Column(
                                //   children: textList,
                                // )
                                ,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

Map<String, dynamic> coords = {
  "Hostels": [
    {
      "title": "Limbdi Hostel",
      "LatLng": LatLng(25.261155, 82.986075),
    },
    {
      "title": "Rajputana Hostel",
      "LatLng": LatLng(25.262417, 82.986178),
    },
    {
      "title": "Dhanraj Giri Hostel",
      "LatLng": LatLng(25.263944, 82.986100),
    },
    {
      "title": "Morvi Hostel",
      "LatLng": LatLng(25.265029, 82.986136),
    },
    {
      "title": "CV Raman Hostel",
      "LatLng": LatLng(25.265925, 82.986291),
    },
    {
      "title": "Ramanujan Hostel",
      "LatLng": LatLng(25.263271, 82.984804),
    },
    {
      "title": "Aryabhatta Hostel",
      "LatLng": LatLng(25.264109, 82.984266),
    },
    {
      "title": "S.N. Bose Hostel",
      "LatLng": LatLng(25.263361, 82.984020),
    },
    {
      "title": "Visvesvaraya Hostel",
      "LatLng": LatLng(25.262324, 82.984066),
    },
    {
      "title": "S.C Dey Hostel",
      "LatLng": LatLng(25.260016, 82.986522),
    },
    {
      "title": "Vivekananda Hostel",
      "LatLng": LatLng(25.259132, 82.986793),
    },
    {
      "title": "Vishwakarma Hostel",
      "LatLng": LatLng(25.257850, 82.985653),
    },
    {
      "title": "GSC(old) Hostel",
      "LatLng": LatLng(25.260617, 82.984292),
    },
    {
      "title": "GSC(ext) Hostel",
      "LatLng": LatLng(25.260247, 82.984530),
    },
    {
      "title": "New Girls Hostel",
      "LatLng": LatLng(25.261197, 82.983797),
    },
  ],
  "Departments": [
    {
      "title": "Biochemical",
      "LatLng": LatLng(25.258664, 82.994163),
    },
    {
      "title": "Biomedical",
      "LatLng": LatLng(25.261706, 82.994374),
    },
    {
      "title": "CSE",
      "LatLng": LatLng(25.262479, 82.993714),
    },
    {
      "title": "Civil",
      "LatLng": LatLng(25.262817, 82.991948),
    },
    {
      "title": "Ceramic",
      "LatLng": LatLng(25.259739, 82.992809),
    },
    {
      "title": "Chemistry",
      "LatLng": LatLng(25.261052, 82.991801),
    },
    {
      "title": "Electronics",
      "LatLng": LatLng(25.262838, 82.990496),
    },
    {
      "title": "Electrical",
      "LatLng": LatLng(25.261384, 82.992030),
    },
    {
      "title": "Engineering Physics",
      "LatLng": LatLng(25.259533, 82.992948),
    },
    {
      "title": "Mechanical",
      "LatLng": LatLng(25.261692, 82.991760),
    },
    {
      "title": "MnC",
      "LatLng": LatLng(25.261849, 82.993503),
    },
    {
      "title": "Mining",
      "LatLng": LatLng(25.269632, 82.992851),
    },
    {
      "title": "Meta",
      "LatLng": LatLng(25.269012, 82.992571),
    },
    {
      "title": "Pharma",
      "LatLng": LatLng(25.259323, 82.993227),
    },

  ],
  "Others": [
    {
      "title": "Main library ",
      "LatLng": LatLng(25.261830, 82.989142),
    },
    {
      "title": "Technex office ",
      "LatLng": LatLng(25.261365, 82.986336),
    },
    {
      "title": "GTAC ",
      "LatLng": LatLng(25.259733, 82.984981),
    },
    {
      "title": "Cafeteria ",
      "LatLng": LatLng(25.260441, 82.991436),
    },
    {
      "title": "Rajputana ground ",
      "LatLng": LatLng(25.262233, 82.987315),
    },
    {
      "title": "Gymkhana ",
      "LatLng": LatLng(25.259643, 82.988997),
    },
    {
      "title": "ADV ",
      "LatLng": LatLng(25.258719, 82.990153),
    },
  ],
  "Lecture Halls": [
    {
      "title": "LT3 ",
      "LatLng": LatLng(25.258845, 82.992690),
    },
    {
      "title": "ABLT ",
      "LatLng": LatLng(25.262779, 82.988583),
    },
  ],
};
