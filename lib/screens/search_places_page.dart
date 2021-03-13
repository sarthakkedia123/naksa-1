

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naksa/constants/constant_colors.dart';
import 'package:naksa/constants/global_variables.dart';
import 'package:naksa/data_models/prediction.dart';
import 'package:naksa/data_provider/appdata.dart';
import 'package:naksa/helpers/requestHelper.dart';
import 'package:naksa/supporter/Prediction_tile.dart';
import 'package:provider/provider.dart';

class SearchPlacesPage extends StatefulWidget {
  static const id = 'search_place_screen';

  @override
  _SearchPlacesPageState createState() => _SearchPlacesPageState();
}

class _SearchPlacesPageState extends State<SearchPlacesPage> {
  var originController = TextEditingController();
  var destinationController = TextEditingController();

  List<Prediction> destinationPredictionList = [];

  void searchPlace(String placeName) async {
    if (placeName.length >=0 ) {
      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapApiKey&sessiontoken=1234567890&components=country:IN';
      var response = await RequestHelper.getRequest(url);
      if (response == 'failed') {
        return;
      }
      if (response['status'] == 'OK') {
        var predictionJson = response['predictions'];

        var thisList = (predictionJson as List).map((e) => Prediction.fromJson(e)).toList();

        setState(() {
          destinationPredictionList = thisList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    String address =
        Provider.of<AppData>(context).originAddress?.placeName ?? '';
    originController.text = address;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 240,
              decoration: BoxDecoration(color: bodyWhiteColor, boxShadow: [
                BoxShadow(
                  color: bodyBlackColor,
                  blurRadius: 3,
                  spreadRadius: .4,
                  offset: Offset(.7, .7),
                )
              ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, top: 30, right: 24, bottom: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        Center(
                          child: Text(
                            'Let\'s Go...',
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: bodyBlackColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.adjust_outlined,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffcdd0cb),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextField(
                                controller: originController,
                                decoration: InputDecoration(
                                  labelText: 'origin',
                                  labelStyle: TextStyle(color: Color(0xff5b5b5b)),
                                  hintText: 'Search Origin',
                                  hintStyle:
                                      TextStyle(color: Color(0xff5b5b5b)),
                                  fillColor: Color(0xffcdd0cb),
                                  filled: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 10, top: 8, bottom: 8),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffcdd0cb),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextField(
                                onChanged: (val) {
                                  searchPlace(val);
                                },
                                // focusNode: focusDestination,
                                controller: destinationController,
                                decoration: InputDecoration(
                                  labelText: 'Destination',
                                  labelStyle: TextStyle(color: Color(0xff5b5b5b)),
                                  hintText: 'Search Destination',
                                  hintStyle:
                                      TextStyle(color: Color(0xff5b5b5b)),
                                  fillColor: Color(0xffcdd0cb),
                                  filled: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 10, top: 8, bottom: 8),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),


        (destinationPredictionList.length > 0)?
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListView.separated(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return PredictionTile(
                      prediction: destinationPredictionList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(
                    thickness: .5,
                    indent: 15,
                    endIndent: 30,
                    color: bodyWhiteColor,
                  ),
                  itemCount: destinationPredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
