
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:zencartos/utils/CustomMarkerHelper.dart';
import 'package:zencartos/sqlite/contribuable.dart';
import 'package:zencartos/sqlite/db_helper.dart';


class ShowMapContribuable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ShowMapContribuableState();
  }
}

class ShowMapContribuableState extends State<ShowMapContribuable> {


  List<Marker> markers = [];


double latInit=0, longInit=0;





  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    if(allMarkers==null){
      allMarkers=List();
      markerLIstupdate();
    }



  }


List<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
  List<Marker> markersList = [];
  bitmaps.asMap().forEach((i, bmp) {
    final city = cities[i];
    markersList.add(Marker(
        markerId: MarkerId(city.name),
        position: city.position,
        icon: BitmapDescriptor.fromBytes(bmp)));
  });
  return markersList;
}

  //variable de la map pour la gestion de la map
  var dbHelper;
  List<Marker> allMarkers ;

  GoogleMapController _controller;
  var marker;





//fonction de transformation chaine en marker
 Widget _getMarkerWidget(String name ,bool etatpayement) {
    return Container(
    
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        height: 100,
        width: 50,
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
        
        child: Column(
          children: <Widget>[
            Container(
              height: 25,
              width: 50,
              child:etatpayement? Text(
                "$name : PAYE",
                style: TextStyle(fontSize: 8, color:etatpayement? Colors.black:Colors.red,fontWeight: FontWeight.bold),
              ):
              Text(
                "$name :  NON PAYE",
                style: TextStyle(fontSize: 8, color:etatpayement? Colors.black:Colors.red,fontWeight: FontWeight.bold),
              )
              
            ),
             Container(
               height: 30,
              child: Image.asset("assets/marker2.png"),
              
            ),
          ],
        ),
      ),
    );
  }

  void markerLIstupdate() async{
    var contribualbes2Mapper= await dbHelper.getcontribuables2();

    setState(() {
      //je recharge ma liste de market
      longInit=Contribuable.fromMap(contribualbes2Mapper[contribualbes2Mapper.length-1]).long;
      latInit=Contribuable.fromMap(contribualbes2Mapper[contribualbes2Mapper.length-1]).lat;
      print("long est $longInit et lat est $latInit");
      allMarkers.clear();
      cities.clear();

      for(int i=0;i<contribualbes2Mapper.length;i++){



        var markertest=Marker(

            markerId: MarkerId('$i'),
            infoWindow:InfoWindow(
              title: '${Contribuable.fromMap(contribualbes2Mapper[i]).name}',
              snippet: '${Contribuable.fromMap(contribualbes2Mapper[i]).sigle}',
            ) ,
            draggable: true,
            onTap: () {
              print('Marker Tapped');
            },
            position: LatLng(Contribuable.fromMap(contribualbes2Mapper[i]).lat, Contribuable.fromMap(contribualbes2Mapper[i]).long)
            //icon: BitmapDescriptor.fromBytes(markerUint8List)

        );
        cities.add( City("${Contribuable.fromMap(contribualbes2Mapper[i]).name}", LatLng(Contribuable.fromMap(contribualbes2Mapper[i]).lat, Contribuable.fromMap(contribualbes2Mapper[i]).long),Contribuable.fromMap(contribualbes2Mapper[i]).autorisation=="oui"),);

        allMarkers.add(markertest);
        print("on a ${Contribuable.fromMap(contribualbes2Mapper[i]).sigle} et ${allMarkers.length}");
      }
        setState(() {
          markers.clear();
          markers=allMarkers;
          //recharge des nouveau marker

            //

          MarkerGenerator(markerWidgets(), (bitmaps) {
            setState(() {
              markers = mapBitmapsToMarkers(bitmaps);
            });
          }).generate(context);




        });

    });

  }


  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoBoston() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(3.8552726, 11.4862735), zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  movetoNewYork() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(3.8552726, 11.4862735), zoom: 12.0),
    ));
  }

  Widget build(BuildContext context) {
      if(allMarkers==null){
        allMarkers=List();
        markerLIstupdate();
      }

    /*
    double longueur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;
     */

    return new Scaffold(
      body: Container(

    child: GoogleMap(
      initialCameraPosition:
      CameraPosition(target: LatLng(3.8302938, 11.3703623), zoom: 12.0),
    markers: Set.from(markers),
    onMapCreated: mapCreated,

    onTap: (latLng ){
    print("${latLng.latitude}  et   ${latLng.longitude}");






    },
    ),


      )

      ,
        );
  }


//liste hor bd de test
  List<City> cities = [
    City("nana", LatLng(3.8302938, 11.3703623),true),

  ];

  List<Widget> markerWidgets() {
    return cities.map((c) => _getMarkerWidget(c.name,c.etatpayement)).toList();
  }


}


//classe city pour le test
class City {
  final String name;
  final LatLng position;
  final bool etatpayement;

  City(this.name, this.position,this.etatpayement);
}