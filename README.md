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

2. Download assets available in this package and store in your projects assets

3. Replaced ```MaterialApp()``` widget with ```GetMaterialApp()```

4. Import package
```
# Import area_measurement_mapbox_map package 
import 'package:area_measurement_mapbox_map/area_measurement_mapbox_map.dart';

# Use it
AreaMeasurementMapScreen(
      accessToken: "pk.eyJ1IjoibmlzaG9uLW5heGEiLCJhIjoiY2xhYnhwbzN0MDUxYTN1bWhvcWxocWlpaSJ9.0FarR4aPxb7F9BHP31msww",
      initialCameraPosition: widget.initialCameraPosition ??
          const CameraPosition(
            target: LatLng(27.706414905613556, 85.42349018023116),
            zoom: 10.0,
          ),
      useDelayedDisposal: true,
    ),
```

