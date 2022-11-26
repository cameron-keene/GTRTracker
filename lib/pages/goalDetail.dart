// dart async library we will refer to when setting up real time updates
import 'dart:async';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// amplify configuration and models that should have been generated for you
import '../models/ModelProvider.dart';
import 'locationWidget.dart';
import '../models/Goal.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';

class goalDetail extends StatefulWidget {
  goalDetail({Key? key, required this.goal}) : super(key: key);
  Goal goal;

  @override
  State<goalDetail> createState() => _goalDetailState();
}

class _goalDetailState extends State<goalDetail> {
  late GoogleMapController mapController;

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Set<Circle> circles = Set.from([
      Circle(
        circleId: CircleId("geofence"),
        center: LatLng(widget.goal.latitude, widget.goal.longitude),
        radius: (widget.goal.radius.toDouble()),
        fillColor: Color.fromARGB(92, 43, 121, 194),
        strokeColor: Color.fromARGB(122, 43, 121, 194),
      )
    ]);
    final LatLng _center = LatLng(widget.goal.latitude, widget.goal.longitude);

    return Expanded(
      child: Column(
        children: [
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
            color: Color.fromARGB(132, 56, 56, 56),
            child: LinearProgressIndicator(
              minHeight: 7,
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 43, 121, 194)),
              value: getPercentage(widget.goal),
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
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(7.0),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 18,
              ),
              circles: circles,
            ),
          )),
          // Expanded(
          //   child: Text("test"),
          // )
        ],
      ),
    );
  }
}

double getPercentage(Goal currentGoal) {
  double percentage = currentGoal.currentDuration / currentGoal.goalDuration;
  // debugPrint("percentage is: " + percentage.toString());
  return percentage;
}
