import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  const MapScreen({
    super.key,
    this.initialLocation =
        const PlaceLocation(latitude: 37.422, longitude: -122.084),
    this.isSelecting = false,
  });

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation = const LatLng(0, 0);

  void selectLocation(position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () {
                  _pickedLocation.latitude == 0
                      ? null
                      : Navigator.of(context).pop(_pickedLocation);
                },
                icon: const Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? selectLocation : null,
        markers: _pickedLocation.latitude == 0
            ? {}
            : {
                Marker(
                  markerId: const MarkerId("m1"),
                  position: _pickedLocation,
                )
              },
      ),
    );
  }
}
