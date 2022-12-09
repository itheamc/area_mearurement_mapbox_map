import 'package:area_measurement_mapbox_map/src/helpers/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/mapbox_land_measurement_controller.dart';

class StyleLayerSelectorBottomSheet extends StatefulWidget {
  const StyleLayerSelectorBottomSheet({Key? key}) : super(key: key);

  @override
  State<StyleLayerSelectorBottomSheet> createState() =>
      _StyleLayerSelectorBottomSheetState();
}

class _StyleLayerSelectorBottomSheetState
    extends State<StyleLayerSelectorBottomSheet> {
  final _landMeasurementMapController =
      Get.find<MapboxLandMeasurementController>();

  final _layers = <_MapStyle>[
    _MapStyle(
      id: 0,
      name: 'Default',
      assetsName: 'assets/icons/satellite_layer.jpg',
    ),
    _MapStyle(
      id: 1,
      name: 'Light',
      assetsName: 'assets/icons/lightlayer.png',
    ),
    _MapStyle(
      id: 2,
      name: 'Dark',
      assetsName: 'assets/icons/dark_layer.jpg',
    ),
    _MapStyle(
      id: 3,
      name: 'Streets',
      assetsName: 'assets/icons/street_layer.jpg',
    ),
    _MapStyle(
      id: 4,
      name: 'Imagery',
      assetsName: 'assets/icons/satellite_street_layer.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 22.0, bottom: 22.0),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Map Type',
                    style: kbody3Style.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _layers
                  .map(
                    (layer) => Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () => _landMeasurementMapController
                              .updateMapBaseLayerStyle(baseStyleId: layer.id),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: _landMeasurementMapController
                                          .selectedStyleId ==
                                      layer.id
                                  ? Colors.red
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 0,
                          child: Image.asset(layer.assetsName,
                              fit: BoxFit.cover,
                              height: (MediaQuery.of(context).size.width) / 6,
                              width: MediaQuery.of(context).size.width / 6),
                        ),
                        Text(
                          layer.name,
                          // style: CustomAppStyle.button14pxSemiBold(context)
                          //     .copyWith(color: Colors.black87),
                        )
                      ],
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

/// Map Style model
class _MapStyle {
  final int id;
  final String name;
  final String assetsName;

  // Constructor
  _MapStyle({
    required this.id,
    required this.name,
    required this.assetsName,
  });
}
