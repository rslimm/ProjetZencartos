import 'package:flutter/material.dart';


class Page_404 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Card(
        child: Column(
          children: <Widget>[
            Text('Page demandée non trouvé', style: TextStyle(fontSize: 22.0, color: Colors.black45)),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}
