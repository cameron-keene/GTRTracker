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

// test imports
// import 'dart:async';

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

  bool showActivities = false;
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  final List<bool> _selectedPage = <bool>[true, false];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> pageTypes = <Widget>[
      Container(
          alignment: Alignment.center,
          width: (MediaQuery.of(context).size.width / 2) - 2,
          child: Text('Details')),
      Container(
          alignment: Alignment.center,
          width: (MediaQuery.of(context).size.width / 2) - 2,
          child: Text('Activities'))
    ];
    final LatLng _center = LatLng(widget.goal.latitude, widget.goal.longitude);

    Set<Circle> circles = Set.from([
      Circle(
        circleId: CircleId("geofence"),
        center: LatLng(widget.goal.latitude, widget.goal.longitude),
        radius: (widget.goal.radius.toDouble()),
        fillColor: Color.fromARGB(92, 43, 121, 194),
        strokeColor: Color.fromARGB(122, 43, 121, 194),
      )
    ]);

    // Use the Goal to create the UI.
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
        children: <Widget>[
          ToggleButtons(
            direction: vertical ? Axis.vertical : Axis.horizontal,
            onPressed: (int index) {
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < _selectedPage.length; i++) {
                  _selectedPage[i] = i == index;
                  if (index == 0) {
                    showActivities = false;
                  } else if (index == 1) {
                    showActivities = true;
                  }
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedColor: Colors.white,
            fillColor: Color.fromARGB(255, 43, 121, 194),
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: _selectedPage,
            children: pageTypes,
          ),
          // ElevatedButton(
          //   style: raisedButtonStyle,
          //   onPressed: () {
          //     debugPrint("button pressed");
          //     setState(() {
          //       showActivities = !showActivities;
          //     });
          //   },
          //   child: Text('Looks like a RaisedButton'),
          // ),

          if (showActivities) ...[
            Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'All Activities',
                          style: GoogleFonts.roboto(
                              color: Color.fromARGB(255, 43, 121, 194),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )))),
            ElevatedButton(
                onPressed: (() {
                  testCreateActivity();
                }),
                child: Text(
                  'Create new geoActivity',
                  style: GoogleFonts.roboto(
                      color: Color.fromARGB(255, 43, 121, 194),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
            Center(
              child: FutureBuilder<List<GeoActivity>>(
                future:
                    getGeoActivities("606ea45e-487b-4a8c-a769-2f6784b3fb37"),
                builder: (BuildContext context,
                    AsyncSnapshot<List<GeoActivity>> snapshot) {
                  List<Widget> children;

                  if (snapshot.connectionState == ConnectionState.done) {
                    try {
                      children = <Widget>[
                        for (GeoActivity i in snapshot.data!) ...[
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.album),
                                  title: Text(i.goalID),
                                  subtitle: Text(
                                      'Music by Julie Gable. Lyrics by Sidney Stein.'),
                                )
                              ],
                            ),
                          ),
                        ]
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
                  return Column(
                    children: children,
                  );
                },
              ),
            )
          ],

          if (!showActivities) ...[
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
              value: .44 * 100, // getProductivity() * 100,
              label: (.44 * 100)
                  .round()
                  .toString(), //(getProductivity() * 100).round().toString()
              onChanged: (value) async {
                // final updatedItem =
                //     widget.goal.copyWith(productivity: (value / 100));
                // await Amplify.DataStore.save(updatedItem);
              },
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

            // Expanded(
            //     child: Padding(
            //   padding: EdgeInsets.all(7.0),
            //   child: GoogleMap(
            //     onMapCreated: _onMapCreated,
            //     initialCameraPosition: CameraPosition(
            //       target: _center,
            //       zoom: 18,
            //     ),
            //     circles: circles,
            //   ),
            // )),
          ],
        ],
      ),
    );
  }

  double getPercentage(Goal currentGoal) {
    double percentage = currentGoal.currentDuration / currentGoal.goalDuration;
    // debugPrint("percentage is: " + percentage.toString());
    return percentage;
  }

  Future<void> createActivity(
      String _goalID, DateTime _timestamp, int _duration) async {
    final item = GeoActivity(
        goalID: _goalID,
        activityTime: TemporalDateTime(_timestamp),
        duration: _duration.toInt(),
        productivity: 1.0);
    await Amplify.DataStore.save(item);
  }

  void testCreateActivity() async {
    debugPrint("create activity");
    String goalID = "606ea45e-487b-4a8c-a769-2f6784b3fb37";
    DateTime timestamp = DateTime.now();
    int duration = 2;
    await createActivity(goalID, timestamp, duration);
    await updateGoalDuration(goalID, duration);
  }

  Future<void> updateGoalDuration(String goalID, int duration) async {
    List<Goal> goalList = [];
    List<GeoActivity> activityList = [];
    try {
      // get the goal and the goal duration
      goalList = await Amplify.DataStore.query(Goal.classType,
          where: Goal.ID.eq(goalID));
    } catch (e) {
      debugPrint("error: " + e.toString());
    }

    debugPrint("first: " + goalList.first.toString());
    final goal = goalList.first;
    int newDuration = goal.currentDuration + duration.toInt();
    // UPDATE GOAL WITH NEW DURATION
    final updatedGoal = goal.copyWith(
        name: goal.name,
        description: goal.description,
        goalDuration: goal.goalDuration,
        currentDuration: newDuration,
        latitude: goal.latitude,
        longitude: goal.longitude,
        Activities: goal.Activities);
    // SAVE THE NEW GOAL
    await Amplify.DataStore.save(updatedGoal);
  }

  Future<List<GeoActivity>> getGeoActivities(String goalID) async {
    List<GeoActivity> activities = [];
    try {
      // get the goal and the goal duration
      activities = await Amplify.DataStore.query(GeoActivity.classType,
          where: GeoActivity.GOALID.eq(goalID));
    } catch (e) {
      debugPrint("error: " + e.toString());
    }
    return activities;
  }

  // double getProductivity() {
  //   return widget.goal.productivity;
  // }
}
