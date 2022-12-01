import 'package:flutter/material.dart';
import 'package:gtrtracker/pages/data.dart';

// amplify packages we will need to use
import 'package:google_fonts/google_fonts.dart';
import 'package:graphic/graphic.dart';
import 'TimeTowardsGoalsPerDay.dart';
import 'package:gtrtracker/functions/functions.dart';

class perceivedProductivityChart extends StatefulWidget {
  const perceivedProductivityChart({super.key});

  @override
  State<perceivedProductivityChart> createState() =>
      _perceivedProductivityChartState();
}

class _perceivedProductivityChartState
    extends State<perceivedProductivityChart> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<IntervalData>>(
        future: getIntervals(),
        builder: (BuildContext context,
            AsyncSnapshot<List<IntervalData>> snapshot1) {
          List<Widget> children;

          if (snapshot1.connectionState == ConnectionState.done) {
            try {
              children = <Widget>[
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Productivity vs Activity Duration',
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
                  margin: const EdgeInsets.only(top: 10),
                  width: 350,
                  height: 300,
                  child: Chart(
                    data: snapshot1.data!,
                    //data: intervalData,
                    variables: {
                      'duration': Variable(
                        accessor: (IntervalData datum) => datum.duration,
                      ),
                      'min': Variable(
                        accessor: (IntervalData datum) => datum.min,
                        scale: LinearScale(min: 0, max: 100),
                      ),
                      'max': Variable(
                        accessor: (IntervalData datum) => datum.max,
                        scale: LinearScale(min: 0, max: 100),
                      ),
                      // 'duration': Variable(
                      //   accessor: (Map map) => map['id'] as String,
                      // ),
                      // 'min': Variable(
                      //   accessor: (Map map) => map['min'] as num,
                      //   scale: LinearScale(min: 0, max: 160),
                      // ),
                      // 'max': Variable(
                      //   accessor: (Map map) => map['max'] as num,
                      //   scale: LinearScale(min: 0, max: 160),
                      // ),
                    },
                    elements: [
                      IntervalElement(
                        position: Varset('duration') *
                            (Varset('min') + Varset('max')),
                        shape: ShapeAttr(
                            value: RectShape(
                                borderRadius: BorderRadius.circular(2))),
                      )
                    ],
                    axes: [
                      Defaults.horizontalAxis,
                      Defaults.verticalAxis,
                    ],
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
          } else if (snapshot1.hasError) {
            children = <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot1.error}'),
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
