// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use

import 'package:google_maps_flutter/google_maps_flutter.dart';

class locationWidget extends StatefulWidget {
  const locationWidget({super.key});

  @override
  State<locationWidget> createState() => _locationWidgetState();
}

class _locationWidgetState extends State<locationWidget> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(29.648198545235758, -82.34372474439299);

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
              target: _center,
              zoom: 18,
            ),
          ),
        ));
  }
}
