// dart async library we will refer to when setting up real time updates
import 'dart:async';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:google_fonts/google_fonts.dart';

// amplify configuration and models that should have been generated for you
import '../amplifyconfiguration.dart';
import '../models/ModelProvider.dart';

import '../models/Goal.dart';

// test imports
// import 'dart:async';
import 'dart:isolate';

// need to hide the location package from the geocoding package
import 'package:geocoding/geocoding.dart' as test;

class detailScreen extends StatefulWidget {
  detailScreen({Key? key, required this.goal}) : super(key: key);
  final Goal goal;
  TextEditingController latitudeController = new TextEditingController();
  TextEditingController longitudeController = new TextEditingController();
  TextEditingController radiusController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();

  @override
  State<detailScreen> createState() => _detailScreenState();
}

class _detailScreenState extends State<detailScreen> {
  @override
  Widget build(BuildContext context) {
    // Use the Goal to create the UI.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        title: Text(widget.goal.name,
            style: TextStyle(
                color: Color.fromARGB(255, 43, 121, 194), fontSize: 20)),
      ),
      backgroundColor: Color.fromARGB(255, 27, 27, 27),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Goal Description',
                          style: GoogleFonts.roboto(
                              color: Color.fromARGB(255, 43, 121, 194),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )))),

            //goal description
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.goal.description ?? "",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                      ),
                    ))),

            Divider(color: Color.fromARGB(255, 255, 255, 255)),

            Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Goal Progress',
                          style: GoogleFonts.roboto(
                              color: Color.fromARGB(255, 43, 121, 194),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )))),

            //progress bar
            Center(
                child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              color: Color.fromARGB(255, 150, 155, 159),
              child: LinearProgressIndicator(
                minHeight: 7,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 43, 121, 194)),
                value: 0.4,
              ),
            )), //update with current hours towards goal
            Divider(color: Color.fromARGB(255, 255, 255, 255)),

            Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Goal Location',
                          style: GoogleFonts.roboto(
                              color: Color.fromARGB(255, 43, 121, 194),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )))),
            // geofenceFeature(),
            TextField(
              controller: widget.locationController,
              onSubmitted: (String value) async {
                List<test.Location> locations =
                    await test.locationFromAddress(value);
                String latitude = locations.elementAt(0).latitude.toString();
                String longitude = locations.elementAt(0).longitude.toString();
                print("latitude: $latitude, longitude: $longitude");
                print("starting geoFencing Service");
              },
            ),
          ],
        ),
      ),
    );
  }
}
