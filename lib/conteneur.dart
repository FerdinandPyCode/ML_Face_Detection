import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:google_ml_kit/google_ml_kit.dart';

class Conteneur extends StatelessWidget {

  late List<Face> detectedfaces;
  late String path;
  late ui.Image image;

  Conteneur({ Key? key,required this.detectedfaces ,required this.path}) : super(key: key){
    File file = File(path);
    loadImage(file);
  }

    void loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => image=value
    );
    }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: FacePainter(image, detectedfaces));
  }
}

class FacePainter extends CustomPainter {
  late ui.Image image;
  late List<Face> faces;
  final List<Rect> rects=[];

  FacePainter(ui.Image img, List<Face> faces) {
    image = img;
    faces = faces;
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = Colors.red;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}