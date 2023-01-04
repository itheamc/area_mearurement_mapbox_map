import 'package:area_measurement_mapbox_map/src/controller/area_measurement_controller.dart';
import 'package:area_measurement_mapbox_map/src/helpers/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl_modified/mapbox_gl_modified.dart';

class MeasurementUiBottomSheet extends StatefulWidget {
  final AreaMeasurementController measurementController;

  const MeasurementUiBottomSheet({
    Key? key,
    required this.measurementController,
  }) : super(key: key);

  @override
  State<MeasurementUiBottomSheet> createState() =>
      _MeasurementUiBottomSheetState();
}

class _MeasurementUiBottomSheetState extends State<MeasurementUiBottomSheet> {
  @override
  Widget build(BuildContext context) {
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
                      widget.measurementController.listOfDrawLatLongs
                          .removeLast();
                      await widget.measurementController.removeDrawing();
                      await widget.measurementController.drawPolygon();
                      await widget.measurementController.drawActiveLine();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.arrowRotateLeft,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () async {
                      widget.measurementController.listOfDrawLatLongs.clear();
                      await widget.measurementController.removeDrawing();

                      await widget.measurementController.drawActiveLine();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.eraser,
                      color: Colors.black,
                    )),
                const Expanded(child: SizedBox()),
                IconButton(
                    onPressed: () async {
                      widget.measurementController.isDrawing.value =
                          !widget.measurementController.isDrawing.value;
                      widget.measurementController.listOfDrawLatLongs.clear();
                      await widget.measurementController.removeDrawing();
                      await widget.measurementController.drawActiveLine();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.xmark,
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
                        value: widget.measurementController.dropDownValue.value,

                        // Down Arrow Icon
                        icon: const Icon(
                          FontAwesomeIcons.chevronDown,
                          size: 16.0,
                        ),

                        // Array list of items
                        items: widget.measurementController.dropItemListMap,

                        onChanged:
                            widget.measurementController.onDropDownValueChanged,
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
                      LatLng? latLng = widget.measurementController
                          .mapController!.cameraPosition!.target;

                      try {
                        widget.measurementController.listOfDrawLatLongs
                            .add([latLng.longitude, latLng.latitude]);

                        await widget.measurementController.removeDrawing();
                        await widget.measurementController.drawPolygon();
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
                            FontAwesomeIcons.plus,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Add point',
                          style: TextStyle(color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                    widget.measurementController.isShowMixedConversion.value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    widget.measurementController.mixedConversion.value,
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
