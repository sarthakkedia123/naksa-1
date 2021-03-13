
import 'package:flutter/material.dart';
import 'package:naksa/constants/constant_colors.dart';
import 'package:naksa/constants/global_variables.dart';
import 'package:naksa/data_models/address.dart';
import 'package:naksa/data_models/prediction.dart';
import 'package:naksa/data_provider/appdata.dart';
import 'package:naksa/helpers/requestHelper.dart';
import 'package:provider/provider.dart';


class PredictionTile extends StatelessWidget {

  final Prediction prediction;

  PredictionTile({this.prediction});

  void getPlaceDetails(String placeID , context) async{
    String url ='https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapApiKey';


    var response = await RequestHelper.getRequest(url);

    if(response == 'failed'){
      return;
    }
    if(response['status'] == 'OK')
      {
        Address thisPlace = Address();
        thisPlace.placeName = response['result']['name'];
        thisPlace.placeId = placeID;
        thisPlace.latitude = response['result']['geometry']['location']['lat'];
        thisPlace.longitude = response['result']['geometry']['location']['lng'];
        Provider.of<AppData>(context, listen:  false).updateDestinationAddress(thisPlace);

        print(thisPlace.placeName);
        Navigator.pop(context , 'getDirection');
      }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: (){
         getPlaceDetails(prediction.placeId, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 8,),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey,),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prediction.mainText, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 17,color: bodyBlackColor),),
                      SizedBox(height: 2,),
                      Text(prediction.secondaryText, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 13,color: bodyBlackColor),),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 8,)
          ],
        ),
      ),
    );
  }
}