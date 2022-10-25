// dart async library we will refer to when setting up real time updates
import 'dart:async';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  late GoogleMapController mapController;
  
  Set<Marker> _markers = {};

  

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    final LatLng _center = LatLng(widget.goal.latitude, widget.goal.longitude);
    Set<Circle> circles = Set.from([Circle(
    circleId: CircleId("geofence"),
    center: LatLng(widget.goal.latitude, widget.goal.longitude),
    radius: 65,
    fillColor: Color.fromARGB(92, 43, 121, 194),
    strokeColor: Color.fromARGB(122, 43, 121, 194),
)]);
    // Use the Goal to create the UI.
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        title: Text(widget.goal.name, style: TextStyle(color: Color.fromARGB(255, 43, 121, 194), fontSize: 20)),
      ),
      backgroundColor: Color.fromARGB(255, 27, 27, 27),
      
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
      
      Center(child:Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: Align(
          alignment: Alignment.centerLeft,
          child:Text('Goal Description',
            style: GoogleFonts.roboto(
            color: Color.fromARGB(255, 43, 121, 194),
            fontSize: 25,
            fontWeight: FontWeight.bold),)))),
      
      //goal description
      Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child:Text(widget.goal.description ?? "",
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,),
            )
          )
      ),
  
      Divider(color: Color.fromARGB(255, 255, 255, 255)),

      Center(child:Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Align(
          alignment: Alignment.centerLeft,
          child:Text('Goal Progress',
            style: GoogleFonts.roboto(
            color: Color.fromARGB(255, 43, 121, 194),
            fontSize: 25,
            fontWeight: FontWeight.bold),
            )
          )
        )
      ),
      
      //progress bar
      Center(child:Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        color: Color.fromARGB(132, 56, 56, 56),
        child:
          LinearProgressIndicator(
            minHeight: 7,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            valueColor: new AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 43, 121, 194)),
            value: 0.4, ),)), //update with current hours towards goal
      Divider(color: Color.fromARGB(255, 255, 255, 255)),
      
      Center(child:Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child:Text('Goal Location',
            style: GoogleFonts.roboto(
            color: Color.fromARGB(255, 43, 121, 194),
            fontSize: 25,
            fontWeight: FontWeight.bold),
            )
          )
        )
      ),
      
      Expanded(child: Padding(
        padding: EdgeInsets.all(7.0), 
        child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 18,),
        circles: circles,
          ),
        )
      ),
    ],
        
      ),
    )
    ;
  }
}
