
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<Uint8List> svgToPngBytes(String assetPath, {int width = 64, int height = 64}) async {
  final PictureInfo pictureInfo = await vg.loadPicture(
    SvgAssetLoader(assetPath),
    null,
  );

  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder);

  // Scale SVG canvas to desired pixel output
  canvas.scale(
    width / pictureInfo.size.width,
    height / pictureInfo.size.height,
  );
  canvas.drawPicture(pictureInfo.picture);

  final ui.Picture picture = recorder.endRecording();
  final ui.Image image = await picture.toImage(width, height);
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  pictureInfo.picture.dispose();
  picture.dispose();
  image.dispose();

  return byteData!.buffer.asUint8List();
}