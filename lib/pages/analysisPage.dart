// flutter and ui libraries
import 'package:flutter/material.dart';
import 'dart:async';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:gtrtracker/widgets/GoalTimePerDay.dart';

import 'package:intl/intl.dart';
import "package:gtrtracker/models/GeoActivity.dart";

final _monthDayFormat = DateFormat('MM-dd');

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  Future<List<GeoActivity>> getActivitiesByDay(DateTime day) async {
    List<GeoActivity> activities = [];

    try {
      activities = await Amplify.DataStore.query(GeoActivity.classType);
      print("numgoals: " + activities.length.toString());
    } catch (e) {
      print("Could not query DataStore: " + e.toString());
    }

    return activities;
  }

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text("Analysis",
              style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(children: const <Widget>[
              GoalTimePerDay(),
            ]))));
  }
}
