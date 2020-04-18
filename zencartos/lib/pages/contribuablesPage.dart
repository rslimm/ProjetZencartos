import 'dart:convert';
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zencartos/sqlite/db_helper.dart';
import 'package:zencartos/sqlite/contribuable.dart';
import 'dart:async';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:flutter/services.dart';

class ContribuablesPage extends StatefulWidget {
  @override
  _ContribuablesPageState createState() => _ContribuablesPageState();
}

enum ConnectionStatus{
  connected,
  disconnected
}

class _ContribuablesPageState extends State<ContribuablesPage> {





  Future<List<Contribuable>> contribuables;
  List<Contribuable> contribuable2=List();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerSigle = TextEditingController();
  TextEditingController controllerNiu = TextEditingController();
  TextEditingController controllerActivity = TextEditingController();






  String name;
  String sigle;
  String niu;
  String activite;

  int curUserId;
  double long=0;
  double lat=0;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;






  Geolocator _geolocator;
  Position _position;
  double longInit=0,latInit=0;

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) { print('status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways).then((status) { print('always status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse)..then((status) { print('whenInUse status: $status'); });


    initialiazePosition();

  }


  void initialiazePosition()async {

    _position=await _geolocator.getCurrentPosition();
    longInit=_position.longitude;
    latInit=_position.latitude;
  }


  @override
  void initState(){
    super.initState();
    initUniqueIdentifierState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
    _geolocator = Geolocator();
    checkPermission();
     setupSocketConnections();
  }
//gestion de id du device 
String _identifier = 'Unknown';



 Future<void> initUniqueIdentifierState() async {
   String identifier;
   try {
     identifier = await UniqueIdentifier.serial;
   } on PlatformException {
     identifier = 'Failed to get Unique Identifier';
   }

   if (!mounted) return;

   setState(() {
     _identifier = identifier;
     print("mon id est $_identifier");
   });
 }


  refreshList(){
    setState(() {
      contribuables = dbHelper.getContribuables();
    });
  }

  void markerLIstupdate() async{
    var contribualbes2Mapper= await dbHelper.getcontribuables2();
  setState(() {
    //je recharge ma liste de market
    print("je montre");
    allMarkers.clear();
    for(int i=0;i<contribualbes2Mapper.length;i++){
      var markertest=Marker(



          markerId: MarkerId('ZenCartosProject'),
          infoWindow:InfoWindow(
            title: '${Contribuable.fromMap(contribualbes2Mapper[i]).name}',
            snippet: '${Contribuable.fromMap(contribualbes2Mapper[i]).sigle}',

          ) ,
          draggable: true,
          onTap: () {
            print('Marker Tapped');
          },
          position: LatLng(Contribuable.fromMap(contribualbes2Mapper[i]).lat, Contribuable.fromMap(contribualbes2Mapper[i]).long)

      );

      allMarkers.add(markertest);

    }
  });
    showMap();
  }
  clearName(){
    controllerName.text = '';
    controllerSigle.text = '';
    controllerNiu.text = '';
    controllerActivity.text = '';
  }

  validate(){
    if (formKey.currentState.validate()){
      formKey.currentState.save();
      if(isUpdating){
        Contribuable e = Contribuable(curUserId, name, sigle, niu, activite,long,lat,DateTime.now(),"non");
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      }else {

        Contribuable e = Contribuable(null, name, sigle, niu, activite,long,lat,DateTime.now(),"non");
        dbHelper.save(e);

      }
      clearName();
      refreshList();
    }
  }

  form(){
    return Form(
      key: formKey,
      child: Padding(
          padding: EdgeInsets.all(15.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        //verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Flexible(
                child: TextFormField(
                  controller: controllerName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Raison'),
                  validator: (val) => val.length == 0 ? 'Entrer la Raison' : null,
                  onSaved: (val) => name = val,
                ),
              ),
              SizedBox(width: 15.0,),
              new Flexible(
                child: TextFormField(
                  controller: controllerSigle,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Sigle'),
                  validator: (val) => val.length == 0 ? 'Entrer le Sigle' : null,
                  onSaved: (val) => sigle = val,
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Flexible(
                child: TextFormField(
                    controller: controllerNiu,

                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'NIU'),
                    validator: (val) => val.length == 0 ? 'Entrer le NIU' : null,
                    onSaved: (val) => niu = val,
                  ),
              ),
              SizedBox(width: 15.0,),
              new Flexible(
                child: TextFormField(
                  controller: controllerActivity,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Activité'),
                  validator: (val) => val.length == 0 ? 'Entrer lactivité' : null,
                  onSaved: (val) => activite = val,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: (){
                  markerLIstupdate();

                },
                child: Text("SHOW MAP"),
              ),

            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: validate,
                child: Text(isUpdating ? 'MAJ' : 'ENREGISTRER'),
              ),
              FlatButton(
                  onPressed: (){
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                    controllerName;
                  },
                  child: Text('ANNULER'),
              ),
            ],
          )

        ],
      ),
      ),
    );
  }

//gestion de mon socket

SocketIOManager manager = SocketIOManager();
  SocketIO socket;

  var status = ConnectionStatus.disconnected;

   void setupSocketConnections() async {
     //le port pour lenvois est 1996
      socket = await manager.createInstance(SocketOptions('http://3.125.6.28:1996'));
      socket.onConnect((data){
        status = ConnectionStatus.connected;
       
        setState(() {
          print("connected...");
        });
      });
      socket.onConnectError((data){
        setState(() {
         print("Connection Error");
         status = ConnectionStatus.disconnected;
        });
        
      });
      socket.onConnectTimeout((data){
           setState(() {
           status = ConnectionStatus.disconnected;
        });
        print("Connection Timed Out");

      });
  
        socket.on("insertionOk", (data){ 
          //sample event

        

       _newsinsertionOk(data);
      });
    
      socket.connect();
    }


 _newsinsertionOk(dynamic message) async {
   
  print("le serveur te dis $message");

  }
    void disconnectSocketConnections() async
    { 
      await manager.clearInstance(socket);
      status = ConnectionStatus.disconnected;
      print("disconnected");
    }


  SingleChildScrollView dataTable(List<Contribuable> contribuables){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
          columns: [
            DataColumn(
                label: Text('NAME'),
            ),
            DataColumn(
              label: Text('SIGLE'),
            ),
            DataColumn(
              label: Text('NIU'),
            ),
            DataColumn(
              label: Text('ACTIVITE'),
            ),
            DataColumn(
              label: Text('DELETE'),
            ),
          ],
         rows: contribuables.map((contribuable) => DataRow(cells: [
           DataCell(
             Text(contribuable.name),
             onTap: (){
               setState(() {
                 isUpdating = true;
                 curUserId = contribuable.id;
               });
               controllerName.text = contribuable.name;
               controllerSigle.text = contribuable.sigle;
               controllerNiu.text = contribuable.niu;
               controllerActivity.text = contribuable.activite;

               /*
               long = contribuable.long;
               lat = contribuable.lat;
                */
             }
           ),

           DataCell(
             Text(contribuable.sigle),

               onTap: (){
                 setState(() {
                   isUpdating = true;
                   curUserId = contribuable.id;
                 });
                 controllerName.text = contribuable.name;
                 controllerSigle.text = contribuable.sigle;
                 controllerNiu.text = contribuable.niu;
                 controllerActivity.text = contribuable.activite;

                 /*
                 long = contribuable.long;
                 lat = contribuable.lat;
                  */
               }
           ),

           DataCell(
             Text(contribuable.niu),

               onTap: (){
                 setState(() {
                   isUpdating = true;
                   curUserId = contribuable.id;
                 });
                 controllerName.text = contribuable.name;
                 controllerSigle.text = contribuable.sigle;
                 controllerNiu.text = contribuable.niu;
                 controllerActivity.text = contribuable.activite;

                 /*
                 long = contribuable.long;
                 lat = contribuable.lat;
                  */
               }
           ),

           DataCell(
             Text(contribuable.activite),

               onTap: (){
                 setState(() {
                   isUpdating = true;
                   curUserId = contribuable.id;
                 });
                 controllerName.text = contribuable.name;
                 controllerSigle.text = contribuable.sigle;
                 controllerNiu.text = contribuable.niu;
                 controllerActivity.text = contribuable.activite;

                 /*
                 long = contribuable.long;
                 lat = contribuable.lat;
                  */
               }
           ),

           DataCell(
             IconButton(
                 icon: Icon(Icons.delete),
                 onPressed: (){
                   dbHelper.delete(contribuable.niu);
                   refreshList();
                    }
                 ),
           ),
                  ]),
              ).toList(),
            ),
          );
  }


Future<void> sendMessage(Contribuable  contribuable) async { 
 
      if(status == ConnectionStatus.connected){
     
        String monPaquet=jsonEncode(contribuable.toMap());
        //je modifie le format de mon json ,"lat":0.0}
       
        socket.emit("NewContribuable",[[monPaquet,_identifier]]);
     
      
      }
     

    }
//fonction qui envoi au serveur 
envoiContribuable() async{
   var contribualbes2Mapper= await dbHelper.getcontribuables2();
   for(int i=0;i<contribualbes2Mapper.length;i++){
     sendMessage(Contribuable.fromMap(contribualbes2Mapper[i]));

   }
}
   void dispose() {
      super.dispose();
      disconnectSocketConnections();
    }
 
  staticsocketStatus(dynamic data) { 
	  print("Socket status: " + data); 
  } 

  list(){
    return Expanded(
      child: FutureBuilder(
          future: contribuables,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return dataTable(snapshot.data);
            }

            if(null == snapshot.data || snapshot.data.length == 0) {
              return Text("Aucune information disponible");
            }

            return CircularProgressIndicator();
          }
      ),
    );
  }

//variable de la map carte
  List<Marker> allMarkers = List();

  GoogleMapController _controller;
var marker;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
PreferredSize(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: (status == ConnectionStatus.connected)? Colors.green:Colors.red,
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              elevation: 0.0,
              title: Text("Liste des Contribuables"),
              centerTitle: true,
              actions: <Widget>[
                FlatButton(onPressed: (){envoiContribuable();}, child: Icon(Icons.refresh, )),

              ],
            ),
          ),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),

    );
  }


  void showMap(
    
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Choisir nouvelle position"),
          content: new Container(
          height: MediaQuery.of(context).size.height/1,
          width: MediaQuery.of(context).size.width/1,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(3.8409096,11.4872675), zoom: 13.0),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
            onTap: (latLng ){
                print("${latLng.latitude}  et   ${latLng.longitude}");

                long=latLng.longitude;
                lat=latLng.latitude;




            },
          ),
        ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
                child: Text("ok"),
                onPressed: () {
                      //je gere la supression de la recette
                   setState(() {
                     allMarkers.add(marker);
                   });   
                     
                      
                      
                      Navigator.of(context).pop();
                    },),
            FlatButton(
              child: Text("Non"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }


  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoBoston() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(42.3601, -71.0589), zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  movetoNewYork() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
    ));
  }


}
