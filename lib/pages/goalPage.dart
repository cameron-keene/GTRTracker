import 'dart:async';
import 'dart:ffi';
import 'dart:core';

// flutter and ui libraries
import 'package:flutter/material.dart';
import 'package:snack/snack.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// amplify configuration and models that should have been generated for you
import 'package:gtrtracker/amplifyconfiguration.dart';
import 'package:gtrtracker/models/ModelProvider.dart';
import 'package:gtrtracker/goalClass/Goal.dart';

// need to hide the location package from the geocoding package
import 'package:geocoding/geocoding.dart' as test;

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  // subscription of Goal QuerySnapshots - to be initialized at runtime
  late StreamSubscription<QuerySnapshot<Goal>> _subscription;

  // loading ui state - initially set to a loading state
  bool _isLoading = true;

  // list of Goals - initially empty
  List<Goal> _goals = [];

  // amplify plugins
  final _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  // final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
  @override
  void initState() {
    // kick off app initialization
    _initializeApp();

    super.initState();
  }

  @override
  void dispose() {
    // to be filled in a later step
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // configure Amplify
    await _configureAmplify();

    // Query and Observe updates to Goal models. DataStore.observeQuery() will
    // emit an initial QuerySnapshot with a list of Goal models in the local store,
    // and will emit subsequent snapshots as updates are made
    //
    // each time a snapshot is received, the following will happen:
    // _isLoading is set to false if it is not already false
    // _goals is set to the value in the latest snapshot
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

  Future<void> _configureAmplify() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        title: const Text('Goals',
            style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
      ),
      backgroundColor: Color.fromARGB(255, 27, 27, 27),
      // body: const Center(child: CircularProgressIndicator()),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoalsList(goals: _goals),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGoalForm()),
          );
        },
        tooltip: 'Add Goal',
        label: Row(
          children: const [Icon(Icons.add), Text('Add Goal')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AddGoalForm extends StatefulWidget {
  const AddGoalForm({Key? key}) : super(key: key);

  @override
  State<AddGoalForm> createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<AddGoalForm> {
  late GoogleMapController mapController;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _goalDurationController = TextEditingController();
  final _addressController = TextEditingController();
  late double latitude;
  late double longitude;
  late double graaa;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _saveGoal() async {
    // get the current text field contents
    final name = _nameController.text;
    final description = _descriptionController.text;
    final goalDuration = _goalDurationController.text; // int.parse
    final location = _addressController.text;

    double latitude;
    double longitude;

    List<test.Location> locations = await test.locationFromAddress(location);
    latitude = locations.elementAt(0).latitude;
    longitude = locations.elementAt(0).longitude;

    print("latitude: $latitude, longitude: $longitude");
    print("starting geoFencing Service");

    // create a new Goal from the form values
    // `isComplete` is also required, but should start false in a new Goal
    final newGoal = Goal(
        name: name,
        description: description,
        goalDuration: int.parse(goalDuration),
        currentDuration: 0,
        radius: graaa.toInt(),
        latitude: latitude,
        longitude: longitude);

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

  Future<void> _saveLocation() async {
    // get the current text field contents
    final location = _addressController.text;

    List<test.Location> locations = await test.locationFromAddress(location);
    latitude = locations.elementAt(0).latitude;
    longitude = locations.elementAt(0).longitude;

    print("latitude: $latitude, longitude: $longitude");
    print("starting geoFencing Service");
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    graaa = (await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => viewGoal(
                latitude: latitude,
                longitude: longitude,
              )),
    ));
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
                    fillColor: Colors.white,
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Description',
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
              TextFormField(
                controller: _goalDurationController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Goal Duration',
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'address',
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
              ElevatedButton(
                  child: const Text('View Goal Location'),
                  onPressed: () =>
                      {_saveLocation(), _navigateAndDisplaySelection(context)}),
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

class viewGoal extends StatefulWidget {
  double latitude;
  double longitude;

  viewGoal({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<viewGoal> createState() => _viewGoalState();
}

class _viewGoalState extends State<viewGoal> {
  late GoogleMapController mapController;
  double rad = 150;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final LatLng _center = LatLng(widget.latitude, widget.longitude);
    Set<Circle> circles = Set.from([
      Circle(
        circleId: CircleId("geofence"),
        center: LatLng(widget.latitude, widget.longitude),
        radius: rad,
        fillColor: Color.fromARGB(92, 43, 121, 194),
        strokeColor: Color.fromARGB(122, 43, 121, 194),
      )
    ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        title: Text("Goal Location",
            style: TextStyle(
                color: Color.fromARGB(255, 43, 121, 194), fontSize: 20)),
      ),
      backgroundColor: Color.fromARGB(255, 27, 27, 27),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(7.0),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 18,
              ),
              circles: circles,
            ),
          )),
          Container(
              //slider
              child: Slider(
            min: 100,
            max: 1000,
            value: rad,
            onChanged: (value) {
              setState(() {
                rad = value;
              });
            },
          )),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, rad);
            },
            child: const Text('Done'),
          )
        ],
      ),
    );
  }
}
