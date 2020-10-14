import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:backgroundgeolocation/backgroundgeolocation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startLocation() async {
    String platformVersion;
    StreamSubscription<Map<String, dynamic>> _onChangedSubscription;
    try {
      var config = {
        "desiredAccuracy": "kCLLocationAccuracyBestForNavigation",
        "activityType": "automotiveNavigation",
        "allowBackgroundLocation": true,
      };
      _onChangedSubscription = Backgroundgeolocation.onChanged(params: config)
          .listen((Map<String, dynamic> result) {
        setState(() {
          var lat = result['lat'];
          var lng = result['lng'];
          print("Lat: $lat Lng: $lng ");
          _platformVersion = "Lat: $lat Lng: $lng ";
        });
      });
    } on PlatformException {
      setState(() {
        platformVersion = 'Failed to get location';
        _platformVersion = platformVersion;
      });
    }
  }

  Future<void> stopLocation() async {
    String platformVersion;
    try {
      platformVersion = await Backgroundgeolocation.stopLocation();
    } on PlatformException {
      platformVersion = 'Failed to stop location';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text('Locations : $_platformVersion\n'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(10),
                        child: RaisedButton(
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          child: Text("Start"),
                          onPressed: () {
                            print("Start");
                            startLocation();
                          },
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: RaisedButton(
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            child: Text("Stop"),
                            onPressed: () {
                              print("Stop");
                              stopLocation();
                            },
                          ))
                    ],
                  ),
                  Expanded(
                      child: new Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              margin: const EdgeInsets.all(10.0),
                              alignment: Alignment.bottomRight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Made with ❤ by"),
                                    Text("Jibran SiddiQui",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]))))
                ],
              ))),
    );
  }
}
