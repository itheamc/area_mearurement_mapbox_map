import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapboxMapHelper extends StatefulWidget {
  /// Mapbox map access token
  final String accessToken;

  /// Mapbox map style uri
  final String? styleUri;

  /// Initial Camera Position
  final CameraPosition? initialCameraPosition;

  /// Method to handle the _onMapCreated callback
  final void Function(MapboxMapController controller)? onMapCreated;

  /// Method to handle the onMapClick callback
  /// [point] -> x and y position of the screen where click happens
  /// [coordinates] -> Latitude and longitude of the clicked location
  final void Function(Point<double> point, LatLng coordinates)? onMapClick;

  /// Method to handle the onMapLongClick callback
  /// [point] -> x and y position of the screen where click happens
  /// [coordinates] -> Latitude and longitude of the clicked location
  final void Function(Point<double> point, LatLng coordinates)? onMapLongClick;

  /// Method to handle the onStyleLoaded callback
  final void Function()? onStyleLoadedCallback;

  /// Method to handle the onUserLocationUpdated callback
  /// It will be triggered whenever user location changed
  /// [location] -> UserLocation object that contains:-
  /// position, altitude, bearing, horizontal and vertical accuracy, speed etc.
  final void Function(UserLocation location)? onUserLocationUpdated;

  final VoidCallback? onCameraIdle;
  final VoidCallback? onMapIdle;

  const MapboxMapHelper({
    Key? key,
    required this.accessToken,
    this.styleUri,
    this.initialCameraPosition,
    this.onMapCreated,
    this.onMapClick,
    this.onMapLongClick,
    this.onStyleLoadedCallback,
    this.onUserLocationUpdated,
    this.onCameraIdle,
    this.onMapIdle,
  }) : super(key: key);

  @override
  State<MapboxMapHelper> createState() => _MapboxMapHelperState();
}

class _MapboxMapHelperState extends State<MapboxMapHelper> {
  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: widget.accessToken,
      styleString: widget.styleUri ?? MapboxStyles.LIGHT,
      initialCameraPosition: widget.initialCameraPosition ??
          const CameraPosition(
            target: LatLng(27.706414905613556, 85.42349018023116),
            zoom: 10.0,
          ),
      onMapCreated: widget.onMapCreated,
      onStyleLoadedCallback: widget.onStyleLoadedCallback,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      myLocationRenderMode: MyLocationRenderMode.NORMAL,
      minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
      doubleClickZoomEnabled: true,
      onMapClick: widget.onMapClick,
      onMapLongClick: widget.onMapLongClick,
      onUserLocationUpdated: widget.onUserLocationUpdated,
      onCameraIdle: widget.onCameraIdle,
      onMapIdle: widget.onMapIdle,
      trackCameraPosition: true,
      compassEnabled: false,
      useDelayedDisposal: true,
    );
  }
}
