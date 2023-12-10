

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
   GoogleMapController? _mapController;
  Location _location = Location();
   LocationData? _currentLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
  }

  void  _getLocation()async {
    try {
      var location = await _location.getLocation();
      setState(() {
        _currentLocation = location;
      });
      _moveToCurrentLocation();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

   void _moveToCurrentLocation() {
     if (_mapController != null && _currentLocation != null) {
       _mapController!.animateCamera(
         CameraUpdate.newCameraPosition(
           CameraPosition(
             target: LatLng(
               _currentLocation!.latitude!,
               _currentLocation!.longitude!,
             ),
             zoom: 15.0,
           ),
         ),
       );
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Tracker'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(0.0, 0.0), // Default initial position
              zoom: 10.0,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _moveToCurrentLocation,
                child:const Icon(Icons.my_location),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
