## Area Measurement Mapbox Map

This is a flutter package based on mapbox_gl plugin to measure the area of the polygon drawn on map.

## How to use it?

1. Added these codes to your pubspec.yaml

```
# Overrides dependencies
dependency_overrides:
  area_mearurement_mapbox_map:
    git:
      url: https://github.com/itheamc/area_mearurement_mapbox_map.git
      ref: 1dac2a7

  mapbox_gl_platform_interface:
    git:
      url: https://github.com/ithebest/maps.git
      ref: master
      path: mapbox_gl_platform_interface/
  mapbox_gl:
    git:
      url: https://github.com/ithebest/maps.git
      ref: master
  get: ^4.6.5
  

# Added assets folder
  assets:
    - assets/icon/
    
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

