import 'package:flutter/material.dart';
import 'package:zencartos/DataTableMySqlDemo/DataTableDemoPage.dart';
import 'package:zencartos/pages/contribuablesPage.dart';
import 'package:zencartos/pages/contribualeEnLigne.dart';

import 'MapTesting.dart';
import 'ShowMapContribuable.dart';



class HomePage extends StatelessWidget {


  
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text('ZenCartos', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),),
      ),
      drawer: Drawer(),

      body: Stack(
        children: <Widget>[
          Container(
            child: CustomPaint(
              painter: ShapesPainter(),
              child: Container(
                height: size.height / 1,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 60.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: <Widget>[
                  Container(
                    child: GestureDetector(
                      onTap: (){
                        // The Event route for New Page here !
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      },
                      child: Card(
                        color: Colors.cyan,
                        elevation: 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.settings, size: 50.0, color: Colors.white,),
                            new Text('Paramètres', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),
      Container(
                    child: GestureDetector(
                      onTap: (){
                        // The Event route for New Page here !
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ContribuableOlineListPage ()));
                      },
                      child: Card(
                        color: Colors.cyan,
                        elevation: 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.network_check, size: 50.0, color: Colors.white,),
                            new Text('List On Line', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: (){
                        // The Event route for New Page here !
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DataTableDemo()));
                      },
                      child: Card(
                        color: Colors.cyan,
                        elevation: 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.person, size: 50.0, color: Colors.white,),
                            new Text('Personnel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: GestureDetector(
                      onTap: (){
                        //The event route for new page
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ContribuablesPage()));
                      },
                      child: Card(
                        color: Colors.cyan,
                        elevation: 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.people, size: 50.0, color: Colors.white,),
                            new Text('Contribuables', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: GestureDetector(
                      onTap: (){
                        // The Event route for New Page here !
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MapTesting()));
                      },
                      child: Card(
                        color: Colors.cyan,
                        elevation: 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.attach_money, size: 50.0, color: Colors.white,),
                            new Text('Caisse', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: GestureDetector(
                      onTap: (){
                        // The Event route for New Page here !
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMapContribuable()));
                      },
                      child: Card(
                        color: Colors.cyan,
                        elevation: 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.map, size: 50.0, color: Colors.white,),
                            new Text('Map', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: GestureDetector(
                      onTap: (){
                        // The Event route for New Page here !
                      },
                      child: Card(
                        color: Colors.cyan,
                        elevation: 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.history, size: 50.0, color: Colors.white,),
                            new Text('Historique', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: GestureDetector(
                      onTap: (){
                        // The Event route for New Page here !
                      },
                      child: Card(
                        color: Colors.cyan,
                        elevation: 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.ac_unit, size: 50.0, color: Colors.white,),
                            new Text('Mon Texte7', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: GestureDetector(
                      onTap: (){
                        // The Event route for New Page here !
                      },
                      child: Card(
                        color: Colors.cyan,
                        elevation: 4.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.ac_unit, size: 50.0, color: Colors.white,),
                            new Text('Mon Texte8', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ShapesPainter extends CustomPainter{
  @override
  void paint( Canvas canvas, Size size){
    final paint = Paint();
    //set the paint color to be white
    paint.color = Colors.white;
    //create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    //draw the rectangle using the paint
    canvas.drawRect(rect, paint);
    paint.color = Colors.blueAccent[400];
    //create a path
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    //close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
