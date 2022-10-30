import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = "";

  Future<void> _getCurrentUserLocation() async {
    var locData = await Location().getLocation();

    var staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: locData.latitude as double,
      longitude: locData.longitude as double,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 370,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: _previewImageUrl.isEmpty
              ? const Text(
                  "No location choosen",
                  textAlign: TextAlign.center,
                )
              : WebView(
                  initialUrl: _previewImageUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
          // Image.network(
          //     _previewImageUrl,
          //     fit: BoxFit.cover,
          //     width: double.infinity,
          //   ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text(
                "Current Location",
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text(
                "Select on map",
              ),
            ),
          ],
        )
      ],
    );
  }
}
