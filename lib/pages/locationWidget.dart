// flutter and ui libraries
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

// amplify packages we will need to use

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrtracker/models/Location.dart';

class locationWidget extends StatefulWidget {
  final double latitude;
  final double longitude;

  locationWidget(this.latitude, this.longitude);

  @override
  State<locationWidget> createState() => _locationWidgetState();
}

class _locationWidgetState extends State<locationWidget> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        child: Padding(
          padding: EdgeInsets.all(7.0),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 18,
            ),
          ),
        ));
  }
}
