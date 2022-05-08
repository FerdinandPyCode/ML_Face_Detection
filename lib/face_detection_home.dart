import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class girlFriendMood extends StatefulWidget {
  const girlFriendMood({Key? key}) : super(key: key);

  @override
  _girlFriendMoodState createState() => _girlFriendMoodState();
}

class _girlFriendMoodState extends State<girlFriendMood> {
  String pathOfImage = "ahsdg";
  String moodImagePath = "";
  String moodDetail = "";
  bool isVisible = false;
  
  FaceDetector detector = GoogleMlKit.vision.faceDetector(
    const FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: true,
      enableTracking: true,
    ),
  );

  @override
  void dispose() {
    super.dispose();
    detector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: isVisible,
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image.file(
                File(pathOfImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: isVisible,
            child: SizedBox(
              height: 200,
              width: 200,
              child: (pathOfImage == "") ? const Center(child: CircularProgressIndicator(),) : CustomPaint(painter: FacePainter(File(pathOfImage),detectedfaces)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: isVisible,
            
            child: Text(
              "Mood is: $moodDetail",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 30,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0,),
        Center(
          child: TextButton(
            onPressed: () async {
              pickImage(0);
              Future.delayed(const Duration(seconds: 5), () {
                extractData(pathOfImage);
              });
            },
            child: const Text(
              "Pick Image With Camera",
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 30,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0,),
        Center(
          child: TextButton(
            onPressed: () async {
              pickImage(1);
              Future.delayed(const Duration(seconds: 7), () {
                extractData(pathOfImage);
              });
            },
            child:const Padding(
              padding:  EdgeInsets.all(8.0),
              child:Text(
                "Pick Image From Gallery",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }

  void pickImage(int n) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(
      source:(n==0)?ImageSource.camera:ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front
      );
    setState(() {
      pathOfImage = image!.path;
    });
  }

  void extractData(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    List<Face> faces = await detector.processImage(inputImage);
    
    print("faces.length   ---------->      ${faces.length}");
    if (faces.isNotEmpty && faces[0].smilingProbability != null) {
      double? prob = faces[0].smilingProbability;
      print("faces.length   ---------->      ${faces.length}");

      if (prob! > 0.8) {
        setState(() {
          moodDetail = "Happy\nProb : ${prob.toString().substring(0,8)}\nNumber of faces: ${faces.length}";
          moodImagePath = "assets/1.jpeg";
        });
      } else if (prob > 0.3 && prob < 0.8) {
        setState(() {
          moodDetail = "Normal\nProb : ${prob.toString().substring(0,8)}\nNumber of faces: ${faces.length}";
          moodImagePath = "assets/1.jpeg";
        });
      } else if (prob > 0.06152385 && prob < 0.3) {
        setState(() {
          moodDetail = "Sad\nProb : ${prob.toString().substring(0,8)}\nNumber of faces: ${faces.length}";
          moodImagePath = "assets/1.jpeg";
        });
      } else {
        setState(() {
          moodDetail = "Angry\nProb : ${prob.toString().substring(0,8)}\nNumber of faces: ${faces.length}";
          moodImagePath = "assets/1.jpeg";
        });
      }
      setState(() {
        isVisible = true;
      });
    }else{
      setState(() {
        moodDetail = "None\nNo Face Found\nProb : 0.00000000\nNumber of faces:  ${faces.length}";
        isVisible = true;
      });
    }
  }
}


/*
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';


class girlFriendMood extends StatefulWidget {
  const girlFriendMood({Key? key}) : super(key: key);

  @override
  _girlFriendMoodState createState() => _girlFriendMoodState();
}

class _girlFriendMoodState extends State<girlFriendMood> {
  String pathOfImage = "";
  String moodImagePath = "";
  String moodDetail = "";
  bool isVisible = false;
  late List<Face> detectedfaces;

  FaceDetector detector = GoogleMlKit.vision.faceDetector(
    const FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: true,
      enableTracking: true,
    ),
  );

  @override
  void dispose() {

    super.dispose();
    detector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 200,
            width: 200,
            child: (pathOfImage=="") ?
            const Icon(Icons.image_aspect_ratio)
            :Image.file(
                      File(pathOfImage),
                      fit: BoxFit.fill,
                    )
          ),
        SizedBox(
            height: 200,
            width: 200,
            child:  (pathOfImage == "") ? const Center(child: CircularProgressIndicator(),) : CustomPaint(painter: FacePainter(File(pathOfImage),detectedfaces)),
          ),
          
        Center(
          child: TextButton(
            onPressed: () async {
              pickImage();
              Future.delayed(const Duration(seconds: 7), () {
                extractData(pathOfImage);
              });
            },
            child: const Text(
              "Pick Image",
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 30,
              ),
            ),
          ),
        )
      ],
    ));
  }

  /*
  body: (image == null) ? const Center(child: CircularProgressIndicator(),):
      Center(
        child: FittedBox(
          child: SizedBox(
            width: image.width.toDouble(),
            height: image.width.toDouble(),
            child: CustomPaint(painter: FacePainter(image, faces))
          ),
        ),
      )
  */

  void pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      pathOfImage = image!.path;
    });
  }

  void extractData(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    List<Face> faces = await detector.processImage(inputImage);
    setState(() {
      detectedfaces=faces;
      isVisible = true;
    });
  }
}*/