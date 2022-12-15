import 'package:example/mapbox_map_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:area_measurement_mapbox_map/area_measurement_mapbox_map.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MeasurementScreen(),
    );
  }
}

/// Measurement Screen
class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({Key? key}) : super(key: key);

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  /// AreaMeasurementController Instance
  final _measurementController = AreaMeasurementController();

  @override
  Widget build(BuildContext context) {
    return AreaMeasurement(
      measurementController: _measurementController,
      showDefaultControllerButtons: false,
      mapboxMap: MapboxMapHelper(
        initialCameraPosition: const CameraPosition(
          target: LatLng(27.706414905613556, 85.42349018023116),
          zoom: 10.0,
        ),
        onMapCreated: _measurementController.onMapCreated,
        onStyleLoadedCallback: _measurementController.onStyleLoadedCallback,
        onUserLocationUpdated: _measurementController.onUserLocationUpdated,
        useDelayedDisposal: true,
      ),
    );
  }
}
