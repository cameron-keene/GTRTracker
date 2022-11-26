// dart async library we will refer to when setting up real time updates
import 'dart:async';
import 'dart:ffi';

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

class activityDetail extends StatefulWidget {
  activityDetail(
      {Key? key,
      required this.goal,
      required this.activity,
      required this.percentage})
      : super(key: key);
  GeoActivity activity;
  Goal goal;
  double percentage;

  @override
  State<activityDetail> createState() => _activityDetailState();
}

class _activityDetailState extends State<activityDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          title: Text(widget.goal.name,
              style: TextStyle(
                  color: Color.fromARGB(255, 43, 121, 194), fontSize: 20)),
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Activity Time',
                            style: GoogleFonts.roboto(
                                color: Color.fromARGB(255, 43, 121, 194),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          )))),

              Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.activity.activityTime.toString(),
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
                            'Activity Duration',
                            style: GoogleFonts.roboto(
                                color: Color.fromARGB(255, 43, 121, 194),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          )))),

              Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.activity.duration.toString() + " hrs" ?? "",
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
                            'Perceived Productivity',
                            style: GoogleFonts.roboto(
                                color: Color.fromARGB(255, 43, 121, 194),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          )))),

              // Slider for Preceived Productivity
              Center(
                  child: Slider(
                min: 0,
                max: 100,
                divisions: 100,
                value: widget.percentage * 100,
                label: (widget.percentage * 100).round().toString(),
                onChanged: (value) async {
                  // final updatedItem =
                  //     widget.activity.copyWith(productivity: (value / 100));
                  // await Amplify.DataStore.save(updatedItem);
                  setState(() {
                    widget.percentage = (value / 100);
                  });
                },
              )), //update with current hours towards goal
              Divider(color: Color.fromARGB(255, 255, 255, 255)),
              ElevatedButton(
                onPressed: () async {
                  final updatedItem = widget.activity
                      .copyWith(productivity: (widget.percentage));
                  await Amplify.DataStore.save(updatedItem);
                  Navigator.pop(context, true);
                },
                child: const Text('Save Activity!'),
              ),
            ]));
  }
}

double getProductivity(GeoActivity currentAct) {
  return currentAct.productivity;
}
