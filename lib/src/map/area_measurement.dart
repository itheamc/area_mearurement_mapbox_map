import 'package:area_measurement_mapbox_map/src/controller/area_measurement_controller.dart';
import 'package:area_measurement_mapbox_map/src/helpers/measurement_ui_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../area_measurement_mapbox_map.dart';
import '../helpers/style_layer_selector_bottomsheet.dart';

class AreaMeasurement extends StatefulWidget {
  final AreaMeasurementController measurementController;
  final Widget mapboxMap;
  final bool showDefaultControllerButtons;

  const AreaMeasurement({
    Key? key,
    required this.measurementController,
    required this.mapboxMap,
    this.showDefaultControllerButtons = true,
  }) : super(key: key);

  @override
  State<AreaMeasurement> createState() =>
      _AreaMeasurementState();
}

class _AreaMeasurementState extends State<AreaMeasurement> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: widget.showDefaultControllerButtons
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Obx(() {
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 375),
                      curve: Curves.ease,
                      right: !widget.measurementController.isDrawing.value
                          ? 17.0
                          : null,
                      top: 40,
                      left: widget.measurementController.isDrawing.value
                          ? 17.0
                          : null,
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
                            if (widget.measurementController.isDrawing.value) {
                              widget.measurementController.hideMeasurementUi();
                            } else {
                              widget.measurementController.showMeasurementUi();
                            }
                          },
                          icon: FaIcon(
                            widget.measurementController.isDrawing.value
                                ? FontAwesomeIcons.xmark
                                : FontAwesomeIcons.ruler,
                          ),
                        ),
                      ),
                    );
                  }),
                  Positioned(
                    right: 17,
                    bottom: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                                Get.bottomSheet(
                                  StyleLayerSelectorBottomSheet(
                                    measurementController:
                                        widget.measurementController,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.layers_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Container(
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
                              onPressed: widget
                                  .measurementController.moveToCurrentLocation,
                              icon: const Icon(
                                Icons.near_me_outlined,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 350),
                    alignment: Alignment.bottomCenter,
                    child: Obx(() {
                      return Visibility(
                        visible: widget.measurementController.isDrawing.value,
                        child: FractionallySizedBox(
                          heightFactor: 0.25,
                          child: MeasurementUiBottomSheet(
                            measurementController: widget.measurementController,
                          ),
                        ),
                      );
                    }),
                  )
                ],
              )
            : null,
        body: Stack(
          children: [
            widget.mapboxMap,
            Obx(
              () {
                return Visibility(
                  visible: widget.measurementController.isDrawing.value,
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
        ),
      ),
    );
  }
}
