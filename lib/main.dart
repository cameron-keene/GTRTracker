// dart async library we will refer to when setting up real time updates
import 'dart:async';
import 'dart:collection';
import 'dart:ffi';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrtracker/goalClass/Goal.dart';
import 'package:gtrtracker/models/GeoActivity.dart';

import './pages/goalPage.dart';

// amplify configuration and models that should have been generated for you
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart' hide Location;

// page import
import './pages/detailPage.dart';

// test imports
// import 'dart:async';
import 'dart:isolate';

import 'package:geofence_service/geofence_service.dart';

import './pages/analysisPage.dart';
// need to hide the location package from the geocoding package
// import 'package:geocoding/geocoding.dart' as test;

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Amplified Goal',
      home: NavBar(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  final geofence testGeo = geofence();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  final _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();

  @override
  void initState() {
    // kick off app initialization
    readFromDatabase();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.testGeo.geofenceInitial();
  }

  late StreamSubscription<QuerySnapshot<Goal>> _subscription;
  bool _isLoading = true;
  List<Goal> _goals = [];

  Future<void> readFromDatabase() async {
    if (Amplify.isConfigured) {
      null;
    } else {
      await Amplify.addPlugins([_dataStorePlugin, _apiPlugin]); //, _authPlugin
    }
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    } on AmplifyException catch (e) {
      throw AmplifyException(e.message);
    }
    _subscription = Amplify.DataStore.observeQuery(Goal.classType)
        .listen((QuerySnapshot<Goal> snapshot) {
      if (mounted) {
        setState(() {
          if (_isLoading) _isLoading = false;
          _goals = snapshot.items;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.testGeo._activityStreamController.close();
    widget.testGeo._geofenceStreamController.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // if (state == AppLifecycleState.resumed) {
    //   debugPrint("active");
    // } else if (state == AppLifecycleState.inactive) {
    //   debugPrint("inactive");
    //   widget.testGeo.geofenceInitial();
    // } else if (state == AppLifecycleState.detached) {
    //   debugPrint("detached");
    //   widget.testGeo.geofenceInitial();
    // } else if (state == AppLifecycleState.paused) {
    //   debugPrint("paused");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillStartForegroundTask(
        onWillStart: () async {
          debugPrint("onWillStart Notification ----------");

          // You can add a foreground task start condition.
          return widget.testGeo._geofenceService.isRunningService;
        },
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'geofence_service_notification_channel',
          channelName: 'Geofence Service Notification',
          channelDescription:
              'This notification appears when the geofence service is running in the background.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          isSticky: false,
        ),
        iosNotificationOptions: const IOSNotificationOptions(),
        notificationTitle: 'Geofence Service is running',
        notificationText: 'Tap to return to the app',
        foregroundTaskOptions: const ForegroundTaskOptions(
          interval: 5000,
          autoRunOnBoot: false,
          allowWifiLock: false,
        ),
        callback: startCallback,
        child: Scaffold(
          body: _buildContentView(),
        ),
      ),
    );
  }

  Widget _buildContentView() {
    if (!_isLoading) {
      // testInitializeGeoFenceList();
      widget.testGeo.geofenceListInitialize(_goals);
    }
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          title: Text("Home",
              style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Current Goals',
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
                ListTileTheme(
                  contentPadding: const EdgeInsets.all(8),
                  iconColor: Color.fromARGB(255, 0, 0, 0),
                  textColor: Color.fromARGB(255, 0, 0, 0),
                  tileColor: Color.fromARGB(255, 255, 255, 255),
                  style: ListTileStyle.list,
                  dense: true,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _goals.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                        shape: border,
                        trailing: Icon(Icons.more_vert),
                        title: Text(
                          _goals[index].name,
                          textScaleFactor: 1.5,
                          style: GoogleFonts.roboto(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  //  ExampleApp(),
                                  detailScreen(goal: _goals[index]),
                            ),
                          );
                        },
                      ));
                    },
                  ),
                )
              ])));
  }

  Widget _buildActivityMonitor() {
    return StreamBuilder<Activity>(
      stream: widget.testGeo._activityStreamController.stream,
      builder: (context, snapshot) {
        final updatedDateTime = DateTime.now();
        final content = snapshot.data?.toJson().toString() ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•\t\tActivity (updated: $updatedDateTime)'),
            const SizedBox(height: 10.0),
            Text(content),
          ],
        );
      },
    );
  }

  Widget _buildGeofenceMonitor() {
    return StreamBuilder<Geofence>(
      stream: widget.testGeo._geofenceStreamController.stream,
      builder: (context, snapshot) {
        final updatedDateTime = DateTime.now();
        final content = snapshot.data?.toJson().toString() ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•\t\tGeofence (updated: $updatedDateTime)'),
            const SizedBox(height: 10.0),
            Text(content),
          ],
        );
      },
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int pageIndex = 0;

  //array to connect pages to navbar
  final pages = [HomePage(), const GoalsPage(), const AnalysisPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //styling
      backgroundColor: const Color(0xffC4DFCB),
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration:
            BoxDecoration(color: Color.fromARGB(255, 27, 27, 27), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(2, -2),
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              //home page
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Color.fromARGB(255, 43, 121, 194),
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              //goal page
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.task_alt_rounded,
                      color: Color.fromARGB(255, 43, 121, 194),
                      size: 35,
                    )
                  : const Icon(
                      Icons.task_alt_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              //analysis page
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.timeline_rounded,
                      color: Color.fromARGB(255, 43, 121, 194),
                      size: 35,
                    )
                  : const Icon(
                      Icons.timeline_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;
  final geofence testGeo = geofence();

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    debugPrint("on event - event count task running in background");
    testGeo.geofenceInitial();
    // call the flutter geofence_service update.

    // Send data to the main isolate.
    sendPort?.send(_eventCount);

    _eventCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}

class geofence {
  final _activityStreamController = StreamController<Activity>();
  final _geofenceStreamController = StreamController<Geofence>();
// Create a [GeofenceService] instance and set options.
  final _geofenceService = GeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      useActivityRecognition: true,
      allowMockLocations: false,
      printDevLog: false,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

  // Create a [Geofence] list.
  final _geofenceList = <Geofence>[];

  // flag to detect first entry
  bool wasEntered = false;

  late DateTime enter;
  late DateTime exit;

  Future<void> createActivity(
      String _goalID, DateTime _timestamp, int _duration) async {
    final item = GeoActivity(
        goalID: _goalID,
        activityTime: TemporalDateTime(_timestamp),
        duration: _duration.toDouble());
    await Amplify.DataStore.save(item);
  }

  Future<void> updateGoalDuration() async {}

  Future<void> calcDuration(
      DateTime enter, DateTime exit, String goalID) async {
    // convert the DateTime to the duration
    // only care about the hours and minutes
    // convert everything to hours.
    Duration enterDur = Duration(hours: enter.hour, minutes: enter.minute);
    Duration exitDur = Duration(hours: exit.hour, minutes: exit.minute);
    Duration result = exitDur - enterDur;
    // debugPrint("result: " + result.inMinutes.toString());
    // reset the enter/exit time
    enter = DateTime(0);
    exit = DateTime(0);
    createActivity(goalID, enter, result.inMinutes);
    updateGoalDuration();
  }

  // This function is to be called when the geofence status is changed.
  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    // print('geofenceRadius: ${geofenceRadius.toJson()}');
    // print('geofenceStatus: ${geofenceStatus.toString()}');
    _geofenceStreamController.sink.add(geofence);
    // TODO: need to create activity corresponding to goal.
    if (geofenceStatus == GeofenceStatus.ENTER && !wasEntered) {
      wasEntered = !wasEntered;
      debugPrint("geofence entered, wait for exit");
      debugPrint('geofence timestamp enter: ${geofence.timestamp}');
      enter = geofence.timestamp!;
      // createActivity(geofence.id, geofence.timestamp!, 'ENTER');
    } else if (geofenceStatus == GeofenceStatus.EXIT && wasEntered) {
      debugPrint('geofence: ${geofence.toJson()}');
      debugPrint('geofence timestamp exit: ${geofence.timestamp}');
      debugPrint("geofence exited need to create activity");
      exit = geofence.timestamp!;
      calcDuration(enter, exit, geofence.id);
      wasEntered = !wasEntered;
      // TODO: since exit need to query previous enter then calc duration.
    }
  }

// This function is to be called when the activity has changed.
  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('prevActivity: ${prevActivity.toJson()}');
    print('currActivity: ${currActivity.toJson()}');
    _activityStreamController.sink.add(currActivity);
  }

// This function is to be called when the location has changed.
  void _onLocationChanged(Location location) {
    print('location: ${location.toJson()}');
  }

// This function is to be called when a location services status change occurs
// since the service was started.
  void _onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

// This function is used to handle errors that occur in the service.
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }

  // TODO: create function to pull all goals then create geofence for each.
  void geofenceListInitialize(List<Goal> _goals) {
    //TODO: create a new geofence object then add it to the list.
    for (var i = 0; i < _goals.length; i++) {
      var goalID = _goals[i].id;
      var lat = _goals[i].latitude;
      var long = _goals[i].longitude;
      Geofence temp = Geofence(
        id: goalID.toString(),
        latitude: lat,
        longitude: long,
        radius: [
          GeofenceRadius(id: goalID + ' radius_50m', length: 50),
        ],
      );
      // _geofenceList.add(temp);
      _geofenceService.addGeofence(temp);
      // debugPrint("goalID: " + goalID);
      // debugPrint("lat: " + lat.toString());
      // debugPrint("long: " + long.toString());
    }
  }

  void geofenceInitial() {
    // TODO: Need to check if already started
    if (!_geofenceService.isRunningService) {
      _geofenceService
          .addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
      _geofenceService.addLocationChangeListener(_onLocationChanged);
      _geofenceService.addLocationServicesStatusChangeListener(
          _onLocationServicesStatusChanged);
      _geofenceService.addActivityChangeListener(_onActivityChanged);
      _geofenceService.addStreamErrorListener(_onError);
      _geofenceService.start(_geofenceList).catchError(_onError);
    }
  }
}
