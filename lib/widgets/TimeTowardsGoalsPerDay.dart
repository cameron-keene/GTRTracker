import 'package:flutter/material.dart';
import 'dart:async';

// amplify packages we will need to use
import 'package:google_fonts/google_fonts.dart';
import 'package:graphic/graphic.dart';
import "package:gtrtracker/pages/data.dart";
import "package:gtrtracker/functions/functions.dart";
import 'package:intl/intl.dart';

final _monthDayFormat = DateFormat('MM-dd');

class GoalTimePerDay extends StatefulWidget {
  const GoalTimePerDay({super.key});

  @override
  State<GoalTimePerDay> createState() => _GoalTimePerDayState();
}

class _GoalTimePerDayState extends State<GoalTimePerDay> {
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
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Total Time Spent Towards Goals Per Day',
                              textAlign: TextAlign.center,
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
                    data: snapshot.data!,
                    //data: timeSeriesSales,
                    variables: {
                      'date': Variable(
                        accessor: (totalTimePerDay datum) => datum.time,
                        //accessor: (TimeSeriesSales datum) => datum.time,
                        scale: TimeScale(
                          formatter: (time) => _monthDayFormat.format(time),
                        ),
                      ),
                      'time spent(min)': Variable(
                        accessor: (totalTimePerDay datum) => datum.total,
                        //accessor: (TimeSeriesSales datum) => datum.sales,
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
