// dart async library we will refer to when setting up real time updates
import 'dart:async';
import 'dart:collection';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrtracker/goalClass/Goal.dart';

// amplify configuration and models that should have been generated for you
import 'amplifyconfiguration.dar
import 'models/ModelProvider.dart' hide Location;

// page import
import './pages/detailPage.dart';

// test imports
// import 'dart:async';
import 'dart:isolate';

import 'package:geofence_service/geofence_service.dart';

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
    debugPrint("starting geofence.....");
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

    if (state == AppLifecycleState.resumed) {
      debugPrint("active");
    } else if (state == AppLifecycleState.inactive) {
      debugPrint("inactive");
      widget.testGeo.geofenceInitial();
    } else if (state == AppLifecycleState.detached) {
      debugPrint("detached");
      widget.testGeo.geofenceInitial();
    } else if (state == AppLifecycleState.paused) {
      debugPrint("paused");
    }
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

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          title: Text("Analysis",
              style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: Column(
          children: <Widget>[
            Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Goal Progress Map',
                          style: GoogleFonts.roboto(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )))),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                )),
            Divider(color: Color.fromARGB(255, 255, 255, 255)),
          ],
        ));

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

class GoalsList extends StatelessWidget {
  const GoalsList({
    required this.goals,
    Key? key,
  }) : super(key: key);

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    return goals.isNotEmpty
        ? ListView(
            padding: const EdgeInsets.all(8),
            children: goals.map((Goal) => GoalItem(goal: Goal)).toList())
        : const Center(
            child: Text('Tap button below to add a Goal!'),
          );
  }
}

class GoalItem extends StatelessWidget {
  const GoalItem({
    required this.goal,
    Key? key,
  }) : super(key: key);

  final double iconSize = 24.0;
  final Goal goal;

  void _deleteGoal(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(goal);
    } catch (e) {
      print('An error occurred while deleting Goal: $e');
    }
  }

  Future<void> _toggleIsComplete() async {
    // copy the Goal we wish to update, but with updated properties
    final updatedGoal = goal.copyWith(isComplete: !goal.isComplete);
    try {
      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedGoal);
    } catch (e) {
      print('An error occurred while saving Goal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _toggleIsComplete();
        },
        onLongPress: () {
          _deleteGoal(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(goal.description ?? 'No description'),
                ],
              ),
            ),
            Icon(
                goal.isComplete
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: iconSize),
          ]),
        ),
      ),
    );
  }
}

class AddGoalForm extends StatefulWidget {
  const AddGoalForm({Key? key}) : super(key: key);

  @override
  State<AddGoalForm> createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<AddGoalForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  // use this as the input into the geocoding feature
  final _locationController = TextEditingController();
  Future<void> _saveGoal() async {
    // get the current text field contents
    final name = _nameController.text;
    final description = _descriptionController.text;

    //TODO create function here to take input from _locationController use the geocoding package then convert to Lat/Long for creating goal.

    // create a new Goal from the form values
    // `isComplete` is also required, but should start false in a new Goal
    final newGoal = Goal(
        name: name,
        description: description.isNotEmpty ? description : null,
        isComplete: false,
        goalDuration: 1020,
        currentDuration: 0,
        latitude: 123.45,
        longitude: 123.45);

    try {
      // to write data to DataStore, we simply pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(newGoal);

      // after creating a new Goal, close the form
      Navigator.of(context).pop();
    } catch (e) {
      print('An error occurred while saving Goal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Goal'),
      ),
      backgroundColor: Color.fromARGB(255, 27, 27, 27),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Name',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Description',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Location',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              ),
              ElevatedButton(
                onPressed: _saveGoal,
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// void main() => runApp(const ExampleApp());

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
  final _geofenceList = <Geofence>[
    Geofence(
      id: 'place_1',
      latitude: 35.103422,
      longitude: 129.036023,
      radius: [
        GeofenceRadius(id: 'radius_100m', length: 100),
        GeofenceRadius(id: 'radius_25m', length: 25),
        GeofenceRadius(id: 'radius_250m', length: 250),
        GeofenceRadius(id: 'radius_200m', length: 200),
      ],
    ),
    Geofence(
      id: 'place_2',
      latitude: 35.104971,
      longitude: 129.034851,
      radius: [
        GeofenceRadius(id: 'radius_25m', length: 25),
        GeofenceRadius(id: 'radius_100m', length: 100),
        GeofenceRadius(id: 'radius_200m', length: 200),
      ],
    ),
  ];
  // This function is to be called when the geofence status is changed.
  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    print('geofence: ${geofence.toJson()}');
    print('geofenceRadius: ${geofenceRadius.toJson()}');
    print('geofenceStatus: ${geofenceStatus.toString()}');
    _geofenceStreamController.sink.add(geofence);
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

  void geofenceInitial() {
    _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geofenceService.addLocationChangeListener(_onLocationChanged);
    _geofenceService.addLocationServicesStatusChangeListener(
        _onLocationServicesStatusChanged);
    _geofenceService.addActivityChangeListener(_onActivityChanged);
    _geofenceService.addStreamErrorListener(_onError);
    _geofenceService.start(_geofenceList).catchError(_onError);
  }
}