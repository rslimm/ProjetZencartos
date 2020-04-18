import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:zencartos/pages/HomePage.dart';
import 'package:zencartos/sqlite/Payement.dart';
import 'package:zencartos/sqlite/contribuable.dart';
import 'package:zencartos/sqlite/db_helper.dart';
import 'package:flutter/services.dart';
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
enum ConnectionStatus{
  connected,
  disconnected
}
class _LoginPageState extends State<LoginPage> {
  bool visible = true;

  Icon eye = Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );
  final formKey = new GlobalKey<FormState>();
//variable champs form
  String _pseudo;
  String _password;

  //validation form
  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print("user : $_pseudo, password : $_password");
      if (_pseudo == 'amhuser' && _password == '12345678') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context ) {
              return AlertDialog(

                title: Center(child: Text('Pseudo ou de passe incorrect'),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                actions: <Widget>[

                  new FlatButton(onPressed: (){
                    Navigator.of(context).pop();
                  },
                    padding: EdgeInsets.all(16.0),
                    child: new Text('Okay', style: TextStyle(color: Colors.blue[900], fontSize: 18.0), textAlign: TextAlign.center,),
                  ),
                ],
              );
            }
        );
      }
    }
  }


//gestin du socket moteur

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
  void sendMessagePayement(String paramettre){ 
      if(status == ConnectionStatus.connected){
        socket.emit("demande_payement",["$paramettre"]);

     
      
      }
     

    }
//1995 est le port pour demander les donner 
    void setupSocketConnections() async {
      socket = await manager.createInstance(SocketOptions('http://3.125.6.28:1996'));
      socket.onConnect((data){
        status = ConnectionStatus.connected;
       setState(() {
          print("connected...");
          sendMessage("actualisation");
          sendMessagePayement("demande_payement");
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
            socket.on("demande_payement", (data){ 
          //sample event

        

       _newsRecherchedemandepayement(data);
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
      
    }

  }


  _newsRecherchedemandepayement(dynamic message) async {
    final data=message;
    
    
  
     for(var tbl in data){

     
           Payement payement=new Payement(tbl["niu"], double.parse("${tbl["montant"]}"), DateTime.parse("${tbl["datePaye"]}"),tbl["idandroid"]);

          
        //controle et insertion dans la bd
          var payementListPrecis=await databaseHelper.getpayementPrecis(payement);
          if(payementListPrecis.length>0){
            print("deja en local make update payement");
           // databaseHelper.update(contribuable);
          }else{
            print("je dois faire insertion du nouveau payement");
            databaseHelper.insertPayement(payement);
          }
      
    }

  }



  static_socketStatus(dynamic data) { 
	  print("Socket status: " + data); 
  } 
      void dispose() {
      super.dispose();
      disconnectSocketConnections();
    }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Form(
            key: formKey,
            child: Container(
              color: Color.fromRGBO(135, 206, 235, 1),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        // backgroundColor: Color.fromRGBO(135, 206, 235, 1),
                        backgroundImage:
                        AssetImage('assets/Images/logo-ZenCartos-Test2.png'),
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      Center(
                        child: Text("Connexion".toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold)),
                      ),
                      Card(
                        elevation: 20,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 60, 10, 100),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Entrez votre Pseudo',
                                    hintText: 'Pseudo'),
                                validator: (val) =>
                                val.length < 1 ? 'Pseudo invalide' : null,
                                onSaved: (val) => _pseudo = val,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: eye,
                                      onPressed: () {
                                        setState(() {
                                          if (this.eye.icon ==
                                              Icons.visibility_off) {
                                            visible = false;
                                            eye = Icon(Icons.visibility);
                                          } else if (this.eye.icon ==
                                              Icons.visibility) {
                                            visible = true;
                                            eye = Icon(Icons.visibility_off);
                                          }
                                        });
                                      },
                                    ),
                                    labelText: 'Entrez votre Mot de passe',
                                    hintText: 'password'),
                                keyboardType: TextInputType.text,
                                obscureText: visible,
                                validator: (val) => val.length < 8
                                    ? 'Mot de passe non valide'
                                    : null,
                                onSaved: (val) => _password = val,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),

                              RaisedButton(
                                  child: new Text(
                                    "Valider",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40.0),
                                  ),
                                  onPressed: _submit,
                                  color: Color.fromRGBO(135, 206, 235, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 237.0,),
                      
                      new Text('Inspired by AMH Consulting-group © ${DateTime.now().year.toString()}'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
