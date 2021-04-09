import 'package:flutter/material.dart';
import 'package:flutter_geolocation/WidgetMap.dart';
import 'package:flutter_geolocation/geolocator_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Geolocator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(),
      home: WidgetMap(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getPosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return Text('${snapshot.data}');
            } else if (snapshot.hasError) {
              return Text(snapshot.toString());
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
