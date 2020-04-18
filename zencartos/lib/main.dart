import 'package:flutter/material.dart';
import 'package:zencartos/pages/LoginPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ZenCartos",
      theme: new ThemeData(
        primaryColor: Colors.blue,
        accentColor: new Color.fromRGBO(250, 250, 250, 1),
      ),
      home: LoginPage(),
      //gestion de toute mes route
      routes: <String, WidgetBuilder>{},
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {





 



  @override
  Widget build(BuildContext context) {
    double longueur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

   
    return new Scaffold(
      // backgroundColor: new Color.fromRGBO(255,182,193, 80),
      resizeToAvoidBottomPadding: true,
     
      backgroundColor: Color.fromARGB(255, 255, 255, 255),

    

//gest
    );
  }

}
