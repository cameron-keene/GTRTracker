// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:google_fonts/google_fonts.dart';
import 'package:graphic/graphic.dart';

import "data.dart";
import 'package:intl/intl.dart';

final _monthDayFormat = DateFormat('MM-dd');

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  // try {
  //   // get the goal and the goal duration
  //   activityList = await Amplify.DataStore.query(GeoActivity.classType,
  //       where: GeoActivity.GOALID.eq(goalID));
  // } catch (e) {
  //   debugPrint("error: " + e.toString());
  // }
  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          title: Text("Analysis",
              style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
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
                  data: timeSeriesSales,
                  variables: {
                    'time': Variable(
                      accessor: (TimeSeriesSales datum) => datum.time,
                      scale: TimeScale(
                        formatter: (time) => _monthDayFormat.format(time),
                      ),
                    ),
                    'sales': Variable(
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
              Container(
                color: Color.fromARGB(255, 255, 255, 255),
                margin: const EdgeInsets.only(top: 10),
                width: 350,
                height: 300,
                child: Chart(
                  data: timeSeriesSales,
                  variables: {
                    'time': Variable(
                      accessor: (TimeSeriesSales datum) => datum.time,
                      scale: TimeScale(
                        formatter: (time) => _monthDayFormat.format(time),
                      ),
                    ),
                    'sales': Variable(
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
            ]))));
  }
}
