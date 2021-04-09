import 'package:flutter/material.dart';
import 'package:flutter_geolocation/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class WidgetMap extends StatefulWidget {
  @override
  _WidgetMapState createState() => _WidgetMapState();
}

class _WidgetMapState extends State<WidgetMap> {
  @override
  void initState() {
    super.initState();

    setState(() {
      getPosition().then((value) => _gotoDefault(value));
    });
  }

  final controller = MapController(location: LatLng(4.5536312, -75.6324356));

  void _gotoDefault(Position p) {
    controller.center = LatLng(p.latitude, p.longitude);
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
  }

  Offset _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    //controller.tileSize = 256 / devicePixelRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text('Map Demo | lfdel24@gmail.com'),
      ),
      body: GestureDetector(
        onDoubleTap: _onDoubleTap,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: (details) {
          print(
              "Location: ${controller.center.latitude}, ${controller.center.longitude}");
        },
        child: Stack(
          children: [
            Map(
              controller: controller,
              builder: (context, x, y, z) {
                final url =
                    'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                return Image.network(
                  url,
                  fit: BoxFit.cover,
                );
              },
            ),
            Center(
              child: Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getPosition().then((value) => _gotoDefault(value));
        },
        tooltip: 'My Location',
        child: Icon(Icons.my_location),
      ),
    );
  }
}
