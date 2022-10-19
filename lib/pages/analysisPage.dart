import 'dart:async';
import 'dart:collection';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(29.648198545235758, -82.34372474439299);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          title: Text("Analysis",
              style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: SingleChildScrollView(
            child: Column(
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
            SizedBox(
                height: 500,
                child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 18,
                    ),
                  ),
                )),
            Divider(color: Color.fromARGB(255, 255, 255, 255)),
            Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Goal Progress',
                          style: GoogleFonts.roboto(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )))),
            SizedBox(
                height: 75.0,
                width: 75.0,
                child: CircularProgressIndicator(
                  value: 0.25,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  valueColor:
                      AlwaysStoppedAnimation(Color.fromARGB(255, 43, 121, 194)),
                  strokeWidth: 12,
                  semanticsLabel: 'Circular progress indicator',
                )),
            Divider(color: Color.fromARGB(255, 255, 255, 255)),
          ],
        )));
  }
}
