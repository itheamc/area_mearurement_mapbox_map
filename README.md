## Area Measurement Mapbox Map

This is a flutter package based on mapbox_gl plugin to measure the area of the polygon drawn on map.

## How to use it?

1. Added these codes to your pubspec.yaml

```
# If you are not using getx then add getx in your dependencies
dependencies
  get: ^4.6.5

# Overrides dependencies
dependency_overrides:
  area_measurement_mapbox_map:
    git:
      url: https://github.com/itheamc/area_measurement_mapbox_map.git
      ref: master

  mapbox_gl_platform_interface:
    git:
      url: https://github.com/ithebest/maps.git
      ref: master
      path: mapbox_gl_platform_interface/
  mapbox_gl:
    git:
      url: https://github.com/ithebest/maps.git
      ref: master


# Added assets folder
  assets:
    - assets/icons/
    
# Add Fonts
  fonts:
    - family: Railway
      fonts:
        - asset: assets/fonts/Raleway-Regular.ttf
        - asset: assets/fonts/Raleway-Italic.ttf
          style: italic
    - family: ProductSans
      fonts:
        - asset: assets/fonts/ProductSans-Regular.ttf
        - asset: assets/fonts/ProductSans-Bold.ttf
          weight: 700
    - family: SoloSellIcons
      fonts:
        - asset: assets/arrow-svg-icons/SoloSellIcons.ttf
        
```

2. Download assets available in this package's assets folder and store in your projects assets

3. Replace ```MaterialApp()``` widget with ```GetMaterialApp()``` if you are using ```MaterialApp()```

4. Import package
```
# Import area_measurement_mapbox_map package 
import 'package:area_measurement_mapbox_map/area_measurement_mapbox_map.dart';

# Use it
  /// AreaMeasurementController Instance
  final _measurementController = AreaMeasurementController();

  @override
  Widget build(BuildContext context) {
    return AreaMeasurementScaffold(
      measurementController: _measurementController,
      mapboxMap:  MapboxMap(
        accessToken: "your_access_token",
        initialCameraPosition: const CameraPosition(
          target: LatLng(27.706414905613556, 85.42349018023116),
          zoom: 10.0,
        ),
        onMapCreated: _measurementController.onMapCreated,
        onStyleLoadedCallback:
        _measurementController.onStyleLoadedCallback,
        onUserLocationUpdated:
        _measurementController.onUserLocationUpdated,
        useDelayedDisposal: true, // If you are using flutter version >= 3.0.0
      ),
    );
  }
```

