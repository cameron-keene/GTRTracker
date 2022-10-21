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

import './goalPage.dart';

// amplify configuration and models that should have been generated for you
import '../amplifyconfiguration.dart';
import '../models/ModelProvider.dart' hide Location;

// page import
import './detailPage.dart';

// test imports
// import 'dart:async';
import 'dart:isolate';

import 'package:geofence_service/geofence_service.dart';

import './analysisPage.dart';

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
