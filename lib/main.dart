import 'package:flutter/material.dart';
import 'face_detection_home.dart';

void main() => runApp(const FaceDetectorApp());

class FaceDetectorApp extends StatelessWidget {
  const FaceDetectorApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const girlFriendMood(),
    );
  }
}