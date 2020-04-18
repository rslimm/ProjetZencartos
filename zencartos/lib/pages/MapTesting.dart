import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

//void main() => runApp(MyApp());

class MapTesting extends StatefulWidget {
  @override
  _MapTestingState createState() => _MapTestingState();
}



class _MapTestingState extends State<MapTesting> {
  final controller = MapController(
    location: LatLng(3.839897, 11.4817778),
  );

  void _incrementCounter() {
    controller.location = LatLng(3.839897, 11.4817778);
  }


  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    controller.tileSize = 256 / devicePixelRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ma Map'),
      ),

      body: Map(
        controller: controller,
        provider: const CachedGoogleMapProvider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Ma localisation',
        child: Icon(Icons.my_location),
      ),

    );
  }
}

/// You can enable caching by using [CachedNetworkImageProvider] from cached_network_image package.
class CachedGoogleMapProvider extends MapProvider {
  const CachedGoogleMapProvider();

  @override
  ImageProvider getTile(int x, int y, int z) {
    //Can also use CachedNetworkImageProvider.
    return NetworkImage(
        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425');
  }
}



//voici le plugin que tu vas ajouter dans ton pubspec file  --->  map: 0.1.0+1