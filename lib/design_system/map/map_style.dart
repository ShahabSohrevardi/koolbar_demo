const darkMapStyle = '''
{
  "version": 8,
  "name": "Koolbar dark",
  "sources": {
    "openstreetmap": {
      "type": "raster",
      "tiles": ["https://tile.openstreetmap.org/{z}/{x}/{y}.png"],
      "tileSize": 256,
      "attribution": "© OpenStreetMap contributors"
    }
  },
  "layers": [
    {"id": "background", "type": "background", "paint": {"background-color": "#07111f"}},
    {
      "id": "openstreetmap",
      "type": "raster",
      "source": "openstreetmap",
      "paint": {
        "raster-opacity": 0.72,
        "raster-brightness-min": 0.04,
        "raster-brightness-max": 0.48,
        "raster-saturation": -0.72,
        "raster-contrast": 0.35,
        "raster-hue-rotate": 198
      }
    }
  ]
}
''';