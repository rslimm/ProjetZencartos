


import 'dart:convert';

import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/material.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:zencartos/sqlite/contribuable.dart';
import 'package:zencartos/sqlite/db_helper.dart';

import 'ContribuablePrecisPage.dart';
import 'package:flutter/services.dart';




class ContribuableOlineListPage extends StatefulWidget{




  @override
  _ContribuableOlineListPageState createState() => _ContribuableOlineListPageState();
}
enum ConnectionStatus{
  connected,
  disconnected
}
class _ContribuableOlineListPageState extends State<ContribuableOlineListPage> {

 List<Contribuable>contribuableList=List();
  













DBHelper databaseHelper= DBHelper();




void deactivate(){
super.deactivate();



  }



  void initState() {
    super.initState();

initUniqueIdentifierState();
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
   
   });
 }

    void disconnectSocketConnections() async
    { 
      await manager.clearInstance(socket);
      status = ConnectionStatus.disconnected;
      print("disconnected");
    }


  void sendMessage(String paramettre){ 
      if(status == ConnectionStatus.connected){
        socket.emit("recherche_contribuable",["$paramettre"]);
     
      
      }
     

    }
  
//1995 est le port pour demander les donner 
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

Future<void> sendMessageNonpaye(Contribuable  contribuable) async { 
 
      if(status == ConnectionStatus.connected){
     
        String monPaquet=jsonEncode(contribuable.toMap());
        //je modifie le format de mon json ,"lat":0.0}
       
        socket.emit("non_paye",[[monPaquet,_identifier]]);
     
      
      }
     

    }

  _newsRechercheResultcontribuable(dynamic message) async {
    final data=message;
    int i=0;
    
   setState(() {
     contribuableList.clear();
   });
     for(var tbl in data){

        Contribuable contribuable=new Contribuable(i, tbl["name"],
         tbl["sigle"],
          tbl["niu"], 
          tbl["activite"], 
          double.parse("${tbl["longitude"]}"),
           double.parse("${tbl["lat"]}"),DateTime.parse("${tbl["datePaye"]}"),"${tbl["autorisation"]}");

           //controle de lettat du contribuable pour son autorisation 
           if(DateTime.now().difference(contribuable.datePaye).inDays>90)
           {
             setState(() {
               contribuable.autorisation="non";
               //implemente une mise a jour direct sur le serveur test avec deux socket pour voir 
              sendMessageNonpaye(contribuable);
             });
           }
        i++;
        //controle et insertion dans la bd
          var contribualeListPrecis=await databaseHelper.getcontribuablesPrecis(contribuable);
          if(contribualeListPrecis.length>0){
            print("deja en local make update");
            databaseHelper.update(contribuable);
          }else{
            print("je dois faire insertion ");
            databaseHelper.save(contribuable);
          }
      setState(() {
        contribuableList.add(contribuable);
      });
    }

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
              title: Text("Liste des Contribuables"),
              centerTitle: true,
              actions: <Widget>[
                FlatButton(onPressed: (){
            sendMessage("actualisation");

                }, child: Icon(Icons.refresh, )),

              ],
            ),
          ),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
     
      body:         ListView(
           
           children: <Widget>[


          Container(
           
           height: longueur/1.3,
           child:  composeur(longueur,largeur),
           
         ),
        

           ],
         ),




















  );


}

Scrollbar 
composeur(double longueur,double  largeur)
{
    
  return Scrollbar(
    
      child: ListView.builder(
      itemCount:contribuableList.length,
      itemBuilder: (BuildContext context,int position){

        return Column(
          children: <Widget>[
            SizedBox(
                 height: longueur / 60,
                ),
            Card
            (      

              color: (contribuableList[position].autorisation!="oui")?Colors.redAccent:Colors.greenAccent,

                 elevation: 12.0,
                
                              child: ListTile
                              (
                 
                 onLongPress: (){
           
                 },
                 onTap: (){
                
                      Navigator.push( context, MaterialPageRoute(builder: (context) => ContribuablePrecisPage (contribuableList[position])),);   
                
               
                 },
                   leading: CircleAvatar(
                                     backgroundColor: Colors.white,
                     child: Image(
                       image: AssetImage('assets/Images/logo-ZenCartos-Test2.png'),
                     ),
                   ),
                   title: Text(" ${contribuableList[position].niu} "),
                   subtitle:Text("${contribuableList[position].name}"),
                  
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