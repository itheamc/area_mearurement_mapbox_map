import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controller/mapbox_area_measurement_controller.dart';
import '../helpers/mapbox_map_helper.dart';
import '../helpers/style_layer_selector_bottomsheet.dart';
import '../helpers/styles.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class AreaMeasurementMapScreen extends StatefulWidget {
  /// Mapbox map access token
  final String accessToken;

  /// Mapbox map style uri
  final String? style;

  /// Initial Camera Position
  final CameraPosition? initialCameraPosition;

  /// Method to handle the onMapClick callback
  /// [point] -> x and y position of the screen where click happens
  /// [coordinates] -> Latitude and longitude of the clicked location
  final void Function(Point<double> point, LatLng coordinates)? onMapClick;

  /// Method to handle the onMapLongClick callback
  /// [point] -> x and y position of the screen where click happens
  /// [coordinates] -> Latitude and longitude of the clicked location
  final void Function(Point<double> point, LatLng coordinates)? onMapLongClick;

  final VoidCallback? onCameraIdle;
  final VoidCallback? onMapIdle;
  final bool useDelayedDisposal;

  /// Language 'en' or 'ne'
  final String language;

  const AreaMeasurementMapScreen({
    Key? key,
    required this.accessToken,
    this.style,
    this.initialCameraPosition,
    this.onMapClick,
    this.onMapLongClick,
    this.onCameraIdle,
    this.onMapIdle,
    this.useDelayedDisposal = false,
    this.language = "en",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AreaMeasurementMapScreenState();
  }
}

class AreaMeasurementMapScreenState extends State<AreaMeasurementMapScreen> {
  /// MapboxAreaMeasurementController
  final _measurementMapboxController =
  Get.put(MapboxAreaMeasurementController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _measurementMapboxController.language = widget.language;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        floatingActionButtonLocation:
        FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            Obx(() {
              return Visibility(
                visible: !_measurementMapboxController.isDrawing.value,
                child: Positioned(
                  right: 17,
                  top: 64,
                  child: Container(
                    height: 48.0,
                    width: 48.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.black38,
                          offset: Offset(0.0, 1.0),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        _measurementMapboxController.isDrawing.value =
                        !_measurementMapboxController.isDrawing.value;
                      },
                      icon: const FaIcon(FontAwesomeIcons.ruler),
                    ),
                  ),
                ),
              );
            }),
            Obx(() {
              return Visibility(
                visible: _measurementMapboxController.isDrawing.value,
                child: Positioned(
                  left: 17,
                  top: 64,
                  child: Container(
                    height: 48.0,
                    width: 48.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.black38,
                          offset: Offset(0.0, 1.0),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        _measurementMapboxController.isDrawing.value =
                        !_measurementMapboxController.isDrawing.value;
                        _measurementMapboxController.listOfDrawLatLongs.clear();
                        _measurementMapboxController.removeDrawing();
                        _measurementMapboxController.drawActiveLine();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
              );
            }),
            Positioned(
              right: 17,
              bottom: 76,
              child: Container(
                height: 48.0,
                width: 48.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Colors.black38,
                      offset: Offset(0.0, 1.0),
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  child: IconButton(
                    onPressed: () {
                      Get.bottomSheet(const StyleLayerSelectorBottomSheet());
                    },
                    icon: const Icon(
                      Icons.layers_outlined,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 17,
              bottom: 20,
              child: Container(
                height: 48.0,
                width: 48.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Colors.black38,
                      offset: Offset(0.0, 1.0),
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  child: IconButton(
                    onPressed:
                    _measurementMapboxController.moveToCurrentLocation,
                    icon: const Icon(
                      Icons.near_me_outlined,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 350),
              alignment: Alignment.bottomCenter,
              child: Obx(() {
                return Visibility(
                  visible: _measurementMapboxController.isDrawing.value,
                  child: FractionallySizedBox(
                    heightFactor: 0.25,
                    child: _ui4MeasurementBottomSheet(),
                  ),
                );
              }),
            )
          ],
        ),
        body: _ui4Body(),
      ),
    );
  }

  /// Ui for body
  Widget _ui4Body() {
    return Stack(
      children: [
        MapboxMapHelper(
          accessToken: widget.accessToken,
          styleUri: widget.style,
          initialCameraPosition: widget.initialCameraPosition,
          onMapCreated: _measurementMapboxController.onMapCreated,
          onStyleLoadedCallback:
          _measurementMapboxController.onStyleLoadedCallback,
          onUserLocationUpdated:
          _measurementMapboxController.onUserLocationUpdated,
          onMapClick: widget.onMapClick,
          onMapLongClick: widget.onMapLongClick,
          onCameraIdle: widget.onCameraIdle,
          onMapIdle: widget.onMapIdle,
          useDelayedDisposal: widget.useDelayedDisposal,
        ),
        Obx(
              () {
            return Visibility(
              visible: _measurementMapboxController.isDrawing.value,
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 25.0,
                    height: 25.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/target.png'),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Ui for the measurement view bottom sheet
  Widget _ui4MeasurementBottomSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () async {
                      _measurementMapboxController.listOfDrawLatLongs
                          .removeLast();
                      await _measurementMapboxController.removeDrawing();
                      await _measurementMapboxController.drawPolygon();
                      await _measurementMapboxController.drawActiveLine();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.arrowRotateLeft,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () async {
                      _measurementMapboxController.listOfDrawLatLongs.clear();
                      await _measurementMapboxController.removeDrawing();

                      await _measurementMapboxController.drawActiveLine();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.eraser,
                      color: Colors.black,
                    )),
                const Expanded(child: SizedBox()),
                IconButton(
                    onPressed: () async {
                      _measurementMapboxController.isDrawing.value =
                      !_measurementMapboxController.isDrawing.value;
                      _measurementMapboxController.listOfDrawLatLongs.clear();
                      await _measurementMapboxController.removeDrawing();
                      await _measurementMapboxController.drawActiveLine();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    )),
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        " Area  ",
                        style: kheading3Style,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      DropdownButton(
                        underline: const SizedBox(
                          height: 2,
                          width: 2,
                        ),
                        // Initial Value
                        value: _measurementMapboxController.dropDownValue.value,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: _measurementMapboxController.dropItemListMap,

                        onChanged:
                        _measurementMapboxController.onDropDownValueChanged,
                      ),
                    ],
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      LatLng? latLng = _measurementMapboxController
                          .mapController!.cameraPosition!.target;

                      try {
                        _measurementMapboxController.listOfDrawLatLongs
                            .add([latLng.longitude, latLng.latitude]);

                        await _measurementMapboxController.removeDrawing();
                        await _measurementMapboxController.drawPolygon();
                      } catch (e) {
                        Get.snackbar('No latitide ', 'No longitude found');
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(50.0)),
                            child: const Icon(
                              Icons.add,
                              color: Colors.grey,
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Add point',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Visibility(
                visible:
                _measurementMapboxController.isShowMixedConversion.value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    _measurementMapboxController.mixedConversion.value,
                    style: kbody4Style,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
