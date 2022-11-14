import 'package:flutter/material.dart';
import 'dart:async';

// amplify packages we will need to use
import 'package:google_fonts/google_fonts.dart';
import 'package:graphic/graphic.dart';
import 'package:gtrtracker/models/Goal.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import "package:gtrtracker/pages/data.dart";
import "package:gtrtracker/models/GeoActivity.dart";

import 'package:intl/intl.dart';

final _monthDayFormat = DateFormat('MM-dd');

class totalTimePerDay {
  final DateTime time;
  int total;

  totalTimePerDay(this.time, this.total);
}

class GoalTimePerDay extends StatefulWidget {
  const GoalTimePerDay({super.key});

  @override
  State<GoalTimePerDay> createState() => _GoalTimePerDayState();
}

class _GoalTimePerDayState extends State<GoalTimePerDay> {
  Future<List<GeoActivity>> getActivities() async {
    List<GeoActivity> activities = [];

    try {
      activities = await Amplify.DataStore.query(
        GeoActivity.classType,
        sortBy: [GeoActivity.ACTIVITYTIME.ascending()],
      ); //need sorted list for chart input
      print("numgoals: " + activities.length.toString());
    } catch (e) {
      print("Could not query DataStore: " + e.toString());
    }

    return activities;
  }

  List<totalTimePerDay> activityTotalPerDay(List<GeoActivity> activities) {
    //iterates through all activities, add new days where they dont exist + total, adds to total where day exists.
    //assumes input of an activity list ordered by activity date in ascending order
    List<totalTimePerDay> totals = [];

    // activities.forEach((element) {
    //   if (totals.isEmpty) {
    //     //start case
    //     totals.add(totalTimePerDay(DateTime(element.activityTime),
    //         element.duration)); //figuring out temporal time to date time
    //   } else if (totals[totals.length - 1].time == element.activityTime) {
    //     //activity on same day as previous
    //     totals[totals.length - 1].total += element.duration;
    //   } else {
    //     //activity on different day as previous
    //     totals.add(totalTimePerDay(element.activityTime, element.duration));
    //   }
    // });

    return totals;
  }

  Future<List<totalTimePerDay>> getTotalTimes() async {
    List<totalTimePerDay> dataPoints = [];
    List<GeoActivity> activities = await getActivities();
    dataPoints = activityTotalPerDay(activities);

    return dataPoints;
  }

  /*  
  PSEUDOCODE FOR TREND: GOAL TIME PER DAY

  get all activities

  separate activities by day + find total time spent in all activities for a given day

  plot day against total
  
  final data structure:
  
  final totalTimeSpent = [
  TotalTimePerDay(DateTime(2017, 9, 19), 5),
  TotaltimePerDay(DateTime(2017, 9, 26), 25),
  TotaltimePerDay(DateTime(2017, 10, 3), 100),
  TotaltimePerDay(DateTime(2017, 10, 10), 75),
];
  */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<totalTimePerDay>>(
        future: getTotalTimes(),
        builder: (BuildContext context,
            AsyncSnapshot<List<totalTimePerDay>> snapshot) {
          List<Widget> children;

          if (snapshot.connectionState == ConnectionState.done) {
            try {
              children = <Widget>[
                Container(
                  child: Text(
                    //snapshot.data![0].toString(),
                    "DADA",
                    style: GoogleFonts.roboto(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Trends',
                              style: GoogleFonts.roboto(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )))),
                const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                    )),
                Container(
                  color: Color.fromARGB(255, 255, 255, 255),
                  margin: const EdgeInsets.only(top: 10),
                  width: 350,
                  height: 300,
                  child: Chart(
                    //data: snapshot.data!,
                    data: timeSeriesSales,
                    variables: {
                      'time': Variable(
                        //accessor: (totalTimePerDay datum) => datum.time,
                        accessor: (TimeSeriesSales datum) => datum.time,
                        scale: TimeScale(
                          formatter: (time) => _monthDayFormat.format(time),
                        ),
                      ),
                      'sales': Variable(
                        //accessor: (totalTimePerDay datum) => datum.total,
                        accessor: (TimeSeriesSales datum) => datum.sales,
                      ),
                    },
                    elements: [
                      LineElement(
                        shape: ShapeAttr(value: BasicLineShape(dash: [5, 2])),
                        selected: {
                          'touchMove': {1}
                        },
                      )
                    ],
                    coord: RectCoord(color: const Color(0xffdddddd)),
                    axes: [
                      Defaults.horizontalAxis,
                      Defaults.verticalAxis,
                    ],
                    selections: {
                      'touchMove': PointSelection(
                        on: {
                          GestureType.scaleUpdate,
                          GestureType.tapDown,
                          GestureType.longPressMoveUpdate
                        },
                        dim: Dim.x,
                      )
                    },
                    tooltip: TooltipGuide(
                      followPointer: [false, true],
                      align: Alignment.topLeft,
                      offset: const Offset(-20, -20),
                    ),
                    crosshair: CrosshairGuide(followPointer: [false, true]),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                    )),
              ];
            } catch (e) {
              children = [Text(e.toString())];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result... (dummy data)'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        });
  }
}
