


import 'dart:convert';
import 'dart:io';

import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:zencartos/pages/testprint.dart';
import 'package:flutter/services.dart';
import 'package:zencartos/sqlite/Payement.dart';
import 'package:zencartos/sqlite/contribuable.dart';
import 'package:zencartos/sqlite/db_helper.dart';
import 'package:intl/intl.dart' show DateFormat;






class ContribuablePrecisPage extends StatefulWidget{

final Contribuable contribuable;
ContribuablePrecisPage (this.contribuable);


  @override
  _ContribuablePrecisPageState createState() => _ContribuablePrecisPageState();
}
enum ConnectionStatus{
  connected,
  disconnected
}
class _ContribuablePrecisPageState extends State<ContribuablePrecisPage> {

 
  









List<Payement>payementList;
final format2 = DateFormat("yyyy-MM-dd ");
DBHelper databaseHelper= DBHelper();
//recharde de la liste de payemement;
rechargeliste()async{
  var payementListMapper=await databaseHelper.getpayement(widget.contribuable);
  setState(() {
    payementList.clear();
  });
for(int i=0;i<payementListMapper.length;i++){

  setState(() {
    payementList.add(Payement.fromMap(payementListMapper[i]));
  });
}
}





void deactivate(){
super.deactivate();



  }

  //gestion de limprimente bluo

 BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  TestPrint testPrint;
  bool tablet=false;
bool connected=false;
 DBHelper dbHelper = DBHelper();

  initSavetoPath()async{
    //read and write
    //image max 300px X 300px
    final filename = 'globe.png';
    var bytes = await rootBundle.load("assets/Images/globe.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes,'$dir/$filename');
    setState(() {
      pathImage='$dir/$filename';
    });
  }


  Future<void> initPlatformState() async {
    bool isConnected=await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if(isConnected) {
      setState(() {
        _connected=true;
      });
    }
  }



  void initState() {
    super.initState();

initUniqueIdentifierState();
  setupSocketConnections();
       initPlatformState();
    initSavetoPath();
    testPrint= TestPrint();
    _getDeviceItems();
  }

    void disconnectSocketConnections() async
    { 
      await manager.clearInstance(socket);
      status = ConnectionStatus.disconnected;
      print("disconnected");
    }

Future<void> sendMessage(Contribuable  contribuable,Payement payement) async { 
 
      if(status == ConnectionStatus.connected){
     
        String contribuable1=jsonEncode(contribuable.toMap());
        String payement1=jsonEncode(payement.mapperpayement());
        //je modifie le format de mon json ,"lat":0.0}
       
        socket.emit("paye",[[contribuable1,_identifier]]);
        socket.emit("payement", [[payement1,_identifier]]);
        
      
      }
     dbHelper.insertPayement(payement).then((onValue){
       Navigator.pop(context);
     });

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
   
   });
 }



//1996 est le port pour denvoi les donner 
    void setupSocketConnections() async {
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
      socket.on("recherche_contribuable", (data){ 
          //sample event

        

       _newsRechercheResultcontribuable(data);
      });

     
      socket.connect();
    }

  SocketIOManager manager = SocketIOManager();
  SocketIO socket;
 
  var status = ConnectionStatus.disconnected;
 TextEditingController montantcontroler = TextEditingController();


  _newsRechercheResultcontribuable(dynamic message) async {
    final data=message;


  }



  static_socketStatus(dynamic data) { 
	  print("Socket status: " + data); 
  } 
      void dispose() {
      super.dispose();
      disconnectSocketConnections();
    }



Widget build(BuildContext context){
 double longueur=MediaQuery.of(context).size.height;
  double largeur=MediaQuery.of(context).size.width;
  if(payementList==null)
    {
      payementList=List();
      rechargeliste();
      
    }
  
  return Scaffold
  (
    

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
              title: Text("Contribuable"),
              centerTitle: true,
              actions: <Widget>[
                FlatButton(onPressed: (){
           

                }, child: Icon(Icons.refresh, )),

              ],
            ),
          ),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
     
      body:         Container(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
               
               children: <Widget>[
                   SizedBox(height: 50,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text(
                          'Device:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 30,),
                        Expanded(
                          child: DropdownButton(
                            items: _getDeviceItems(),
                            onChanged: (value) => setState(() => _device = value),
                            value: _device,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                  
                tablet?SizedBox(height: 1,):  
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.brown,
                          onPressed:(){
                            initPlatformState();
                          },
                          child: Text('Refresh', style: TextStyle(color: Colors.white),),
                        ),
                        SizedBox(width: 20,),
                        RaisedButton(
                          color: _connected ?Colors.red:Colors.green,
                          onPressed:
                          _connected ? _disconnect : _connect,
                          child: Text(_connected ? 'Disconnect' : 'Connect', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                         
                         
                         
                      
                 SizedBox(height: 50,),
                 Text("NAME : ${widget.contribuable.name}"),
                  Text("SIGLE : ${widget.contribuable.sigle}"),
                   Text("NIU : ${widget.contribuable.niu}"),
                   Text("ACTIVITE : ${widget.contribuable.activite}"),
                    Text("DATE : ${ format2.format(widget.contribuable.datePaye) }"),
                   Text("AUTORISATION : ${widget.contribuable.autorisation}"),
           
          
                    Text("LISTE DE PAYEMENT"),
            Container(
           
           height: longueur/4,
           child:  composeur(longueur,largeur),
           
         ),
                   Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            
             
            
                new Flexible(
                  child: TextFormField(
                    controller: montantcontroler,
                    onChanged: (val){

                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'montant'),
                    validator: (val) => val.length == 0 ? 'Entrer le montant' : null,

                  ),
                ),
            
            ],
          ),


                     Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                      child:  RaisedButton(
                        color: Colors.blue,
                        onPressed:() async {
                       setState(() {
                            widget.contribuable.autorisation="oui";
                          widget.contribuable.datePaye=widget.contribuable.datePaye.add(Duration(days: 90));
                       });
                          Payement payement=Payement(widget.contribuable.niu, double.parse(montantcontroler.text), widget.contribuable.datePaye,"$_identifier");

                         // sendMessage(widget.contribuable,payement);
                         int resuitImpre=await  testPrint.sample(pathImage,widget.contribuable,payement);
                         if(resuitImpre==1){
                           
                        
                             sendMessage(widget.contribuable,payement);
                           
                         }
                         // je ferme a page Navigator.pop(context);
                        },
                        child: Text('PAYER ', style: TextStyle(color: Colors.white)),
                      ),
                    ),
            

               ],
             ),
        ),
      ),




















  );


}


//ici dans la liste des bluetout je recherche IposPrinter si il est la on est pas sur la tablet
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      //le premier que il trouve est mis dans ladresse 
    
      _device=_devices[0];

      print("je refress  ${_device.name}");

      _devices.forEach((device) {
        if(device.name=="IposPrinter"){
          tablet=true;
          _device=device;
          _connect();
          connected=true;
        }
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }


  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
          print("connection oik");
        }
      });
    }
  }


  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future show(
      String message, {
        Duration duration: const Duration(seconds: 3),
      }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }



Scrollbar 
composeur(double longueur,double  largeur)
{
    
  return Scrollbar(
    
      child: ListView.builder(
      itemCount:payementList.length,
      itemBuilder: (BuildContext context,int position){

        return Column(
          children: <Widget>[
            SizedBox(
                 height: longueur / 60,
                ),
            Card
            (      

              color: Colors.greenAccent,

                 elevation: 12.0,
                
                              child: ListTile
                              (
                 
                 onLongPress: (){
           
                 },
                 onTap: (){
                
                     
                 },
                   leading: CircleAvatar(
                                     backgroundColor: Colors.white,
                     child: Image(
                       image: AssetImage('assets/Images/logo-ZenCartos-Test2.png'),
                     ),
                   ),
                   title: Text(" ${payementList[position].niu} "),
                   subtitle:Text("Date : ${format2.format(payementList[position].datePaye)   }  Montant :${payementList[position].montant}"),
                  
                 ),
            
            ),
          SizedBox(
                 height: longueur / 60,
                ),
          ],
        );
     
     
     
      }

    ),
  );
} 




}