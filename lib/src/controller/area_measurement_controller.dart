import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;

class AreaMeasurementController extends GetxController {
  /// MapboxMapController
  MapboxMapController? _mapController;

  MapboxMapController? get mapController => _mapController;

  /// UserLocation
  UserLocation? userLocation;

  /// Selected Style Id
  final _selectedStyleId = 0.obs;

  int get selectedStyleId => _selectedStyleId.value;

  /// Method to handle onMapCreatedCallback
  void onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    _mapController?.addListener(_cameraMovingListener);
    moveToCurrentLocation();
  }

  /// Method to handle onStyleLoadedCallback
  void onStyleLoadedCallback() {}

  /// Method to listen the camera moving callback
  void _cameraMovingListener() {
    if (_mapController != null && !_mapController!.isCameraMoving) {
      drawActiveLine();
    }
  }

  /// Method to listen the camera moving callback
  void onUserLocationUpdated(UserLocation userLocation) {
    userLocation = userLocation;
  }

  /// Method to navigate to current location
  Future<void> moveToCurrentLocation() async {
    final latLng = userLocation?.position ??
        await _mapController?.requestMyLocationLatLng();
    if (latLng != null) {
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(latLng.latitude, latLng.longitude),
          16.0,
        ),
      );
    }
  }

  /// ----------------------Drawing Related---------------------
  final isDrawing = false.obs;
  final areaOfPolygon = 0.0.obs;

  bool pathRemoved = true;

  List<List<double>> listOfDrawLatLongs = [];

  /// for area conversion
  Map dropItems = {
    'Sq. meter': 0.00,
    'Acre': 0.00,
    'Bigha': 0.00,
    'kattha': 0.00,
    'Dhur': 0.00,
    'Ropani': 0.00,
    'Aana': 0.00,
    'Paisa:': 0.00,
    'Dam': 0.00,
    'Sq. feet': 0.00
  };

  /// dropdown value
  final dropDownValue = 'Sq. meter'.obs;
  List<DropdownMenuItem<Object>>? dropItemListMap = [];

  final isShowMixedConversion = false.obs;
  final mixedConversion = '0 ropani, 0 aana, 0 paisa,0 dam'.obs;

  void populateDropdownList() {
    dropItemListMap!.clear();
    dropItems.forEach((key, value) {
      dropItemListMap!.add(DropdownMenuItem(
        value: key,
        child: Text(' ${value.toStringAsFixed(3)} $key'),
      ));
    });
  }

  void onDropDownValueChanged(newValue) {
    dropDownValue.value = newValue!.toString();
    isShowMixedConversion.value = ['Ropani', 'Aana', 'Aana', 'Paisa:', 'Dam']
        .contains(dropDownValue.value);
  }

  /// Method to remove polyline
  // Future<void> removePolyLine(String layer) async {
  //   try {
  //     await _mapController?.removeLayer(layer);
  //
  //     await _mapController?.removeSource('test_polyline_source');
  //     pathRemoved = true;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("==========>[ layer does not exit ]<===========");
  //     }
  //   }
  // }

  Future<void> drawPolygon() async {
    List<List> localList = List.from(listOfDrawLatLongs);

    if (listOfDrawLatLongs.length > 2) {
      localList.add(listOfDrawLatLongs[0]);
      try {
        Map<String, dynamic> dummyData = {
          "type": "FeatureCollection",
          "features": [
            {
              "type": "Feature",
              "properties": {},
              "geometry": {
                "coordinates": [localList],
                "type": "Polygon"
              }
            }
          ]
        };

        if (localList.isNotEmpty) {
          double tempArea = toolkit.SphericalUtil.computeArea(
                  localList.map((e) => toolkit.LatLng(e[1], e[0])).toList())
              as double;

          dropItems = {
            'Sq. meter': tempArea,
            'Acre': tempArea / 4046.86,
            'Bigha': tempArea / 6772.631616,
            'kattha': tempArea / 338.6315808,
            'Dhur': tempArea / 16.93157904,
            'Ropani': tempArea / 508.737047,
            'Aana': tempArea / 31.79606544,
            'Paisa:': tempArea / 7.94901636,
            'Dam': tempArea / 1.98725409,
            'Sq. feet': tempArea / 0.09290304
          };

          populateDropdownList();

          //Convert into mixed units
          double dam = tempArea / 1.98725409;
          int ropani, aana, paisa;

          ropani = dam ~/ 256;

          aana = ((dam - (ropani * 256))) ~/ 16;
          paisa = (dam - (ropani * 256) - (aana * 16)) ~/ 4;

          dam = dam - (ropani * 256) - (aana * 16) - (paisa * 4);

          mixedConversion(
              '$ropani ropani, $aana aana, $paisa paisa,${dam.toStringAsFixed(3)} dam');
          //Mixed unit conversion ends

          /// Checking if the dropdown value is in the list of values.
          isShowMixedConversion.value = [
            'Ropani',
            'Aana',
            'Aana',
            'Paisa:',
            'Dam'
          ].contains(dropDownValue.value);

          /// The above code is calculating the area of a polygon.
          areaOfPolygon(tempArea);
        }

        await _mapController?.addGeoJsonSource(
          'draw_source',
          dummyData,
        );

        debugPrint('==============================> ADDING POLYGOMN');

        await _mapController?.addLayer(
          'draw_source',
          'draw_polygon_layer',
          const FillLayerProperties(
            fillColor: 'blue',
            fillOpacity: 0.2,
            fillOutlineColor: 'red',
          ),
        );
      } catch (e) {
        debugPrint('exception thrown from controller $e');
      }
    }

    drawLine();
  }

  /// Method to draw line
  Future<void> drawLine() async {
    if (listOfDrawLatLongs.isNotEmpty) {
      List<List> localList = List.from(listOfDrawLatLongs);
      try {
        if (listOfDrawLatLongs.length > 1) {
          localList.add(listOfDrawLatLongs[0]);
        }

        Map<String, dynamic> dummyData = {
          "type": "FeatureCollection",
          "features": [
            {
              "type": "Feature",
              "properties": {},
              "geometry": {
                "coordinates": localList, //listOfDrawLatLongs,
                "type": "LineString"
              }
            }
          ]
        };
        try {
          _mapController?.removeLayer('draw_layer_line');
          await _mapController?.removeSource('draw_line_source');
        } catch (e) {
          debugPrint('layer does not exit ');
        }

        await _mapController?.addGeoJsonSource(
          'draw_line_source',
          dummyData,
        );

        await _mapController?.addLayer(
            'draw_line_source',
            'draw_layer_line',
            const LineLayerProperties(
              lineColor: '#FEE901',
              lineWidth: 1.5,
            ));

        drawDrawIcons();
      } catch (e) {
        debugPrint('exception thrown from controller $e');
      }
    }
  }

  /// Method to draw draw icons
  Future<void> drawDrawIcons() async {
    List<List> localList = List.from(listOfDrawLatLongs);

    try {
      await _mapController?.removeLayer('draw_layer_point');

      await _mapController?.removeSource('draw_point_source');
    } catch (e) {
      debugPrint('layer does not exit $e');
    }

    Map<String, dynamic> dummyData = {
      "type": "FeatureCollection",
      "features": localList
          .map((e) => {
                "type": "Feature",
                "properties": {},
                "geometry": {"coordinates": e, "type": "Point"}
              })
          .toList()
    };
    await _mapController?.addSource(
        "draw_point_source",
        GeojsonSourceProperties(
            data: dummyData,
            cluster: false,
            clusterMaxZoom: 14, // Max zoom to cluster points on
            clusterRadius:
                50 // Radius of each cluster when clustering points (defaults to 50)

            ));

    _mapController?.addLayer(
      "draw_point_source",
      "draw_layer_point",
      const CircleLayerProperties(
          circleColor: 'white',
          circleOpacity: 0.9,
          circleRadius: 6,
          circleStrokeColor: '#6CB861',
          circleStrokeWidth: 2),
    );
  }

  /// Method to draw active lines
  Future<void> drawActiveLine() async {
    if (listOfDrawLatLongs.isNotEmpty) {
      if (listOfDrawLatLongs.length < 3) {
        areaOfPolygon.value = 0.0;
        dropItems = {
          'Sq. meter': 0.00,
          'Acre': 0.00,
          'Bigha': 0.00,
          'kattha': 0.00,
          'Dhur': 0.00,
          'Ropani': 0.00,
          'Aana': 0.00,
          'Paisa:': 0.00,
          'Dam': 0.00,
          'Sq. feet': 0.00
        };
        populateDropdownList();
        mixedConversion.value = '0 ropani, 0 aana, 0 paisa,0 dam';
      }
      try {
        LatLng? latLang = _mapController?.cameraPosition!.target;

        Map<String, dynamic> dummyData = {
          "type": "FeatureCollection",
          "features": [
            {
              "type": "Feature",
              "properties": {},
              "geometry": {
                "coordinates": [
                  listOfDrawLatLongs.last,
                  [latLang?.longitude, latLang?.latitude]
                ],
                "type": "LineString"
              }
            }
          ]
        };
        try {
          _mapController?.removeLayer('draw_active_layer_line');
          await _mapController?.removeSource('draw_active_line_source');
        } catch (e) {
          debugPrint('layer does not exit ');
        }

        await _mapController?.addGeoJsonSource(
          'draw_active_line_source',
          dummyData,
        );

        await _mapController?.addLayer(
          'draw_active_line_source',
          'draw_active_layer_line',
          const LineLayerProperties(
              lineColor: '#6CB861', lineWidth: 1, linePattern: 2),
          belowLayerId: 'draw_layer_point',
        );
      } catch (e) {
        debugPrint('exception thrown from controller $e');
      }
    } else {
      try {
        _mapController?.removeLayer('draw_active_layer_line');
        await _mapController?.removeSource('draw_active_line_source');
      } catch (e) {
        debugPrint('layer does not exit ');
      }
      areaOfPolygon(0.0);
      dropItems = {
        'Sq. meter': 0.00,
        'Acre': 0.00,
        'Bigha': 0.00,
        'kattha': 0.00,
        'Dhur': 0.00,
        'Ropani': 0.00,
        'Aana': 0.00,
        'Paisa:': 0.00,
        'Dam': 0.00,
        'Sq. feet': 0.00
      };
      populateDropdownList();
      mixedConversion.value = '0 ropani, 0 aana, 0 paisa,0 dam';
    }
  }

  /// Methods to remove drawings
  Future<void> removeDrawing() async {
    try {
      await _mapController?.removeLayer('draw_polygon_layer');

      await _mapController?.removeSource('draw_source');
    } catch (e) {
      debugPrint('layer does not exit $e');
    }

    try {
      await _mapController?.removeLayer('draw_layer_line');
      await _mapController?.removeSource('draw_line_source');
    } catch (e) {
      debugPrint('layer does not exit $e');
    }

    try {
      await _mapController?.removeLayer('draw_layer_point');

      await _mapController?.removeSource('draw_point_source');
    } catch (e) {
      debugPrint('layer does not exit $e');
    }
  }

  String getMabBoxStyles({int stylesId = 0}) {
    String style = MapboxStyles.LIGHT;
    switch (stylesId) {
      case 1:
        style = MapboxStyles.LIGHT;
        break;
      case 2:
        style = MapboxStyles.DARK;
        break;
      case 3:
        style = MapboxStyles.MAPBOX_STREETS;
        break;
      case 4:
        style = MapboxStyles.SATELLITE;
        break;
      default:
        style = MapboxStyles.LIGHT;
    }
    return style;
  }

  @override
  void onInit() {
    super.onInit();
    populateDropdownList();
  }

  /// Method to show the measurement ui
  void showMeasurementUi() {
    isDrawing.value = true;
  }

  /// Method to hide the measurement ui
  void hideMeasurementUi() {
    isDrawing.value = false;
    listOfDrawLatLongs.clear();
    removeDrawing();
    drawActiveLine();
  }

  /// Method to update map style
  void updateMapStyle({int styleId = 0}) {
    _selectedStyleId.value = styleId;

    // setStyle() -> This method is not available in official mapbox_gl plugin
    // It has been added in https://github.com/ithebest/maps (fork of mapbox_gl)
    // In order to make it work you must override mapbox_gl package with:
    // dependency_overrides:
    //   mapbox_gl_platform_interface:
    //     git:
    //       url: https://github.com/ithebest/maps.git
    //       ref: master
    //       path: mapbox_gl_platform_interface/
    //   mapbox_gl:
    //     git:
    //       url: https://github.com/ithebest/maps.git
    //       ref: master
    _mapController?.setStyle(getMabBoxStyles(stylesId: styleId));
  }
}
