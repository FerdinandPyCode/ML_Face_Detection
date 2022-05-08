/*import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:ui' as ui;

class FaceDetection extends StatefulWidget {

  late File file;
  FaceDetection(this.file, {Key? key}) : super(key: key);
  
  // FaceDetection(this.file);

  @override
  _FaceDetectionState createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  late ui.Image image;
  late List<Face> faces;
  var result = "";

  @override
  void initState() {
    super.initState();
    detectFaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Detection"),
      ),

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
    );
  }

   void loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        image = value;
      }),
    );
  }


  void detectFaces() async{
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(widget.file);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
      const FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true
        ));
        
    List<Face> detectedFaces = await faceDetector.processImage(visionImage);
    for (var i = 0; i < detectedFaces.length; i++) {
      final double? smileProbablity = detectedFaces[i].smilingProbability;
      print("Smiling Probablity for $i: $smileProbablity");
    }
      faces = detectedFaces;
      loadImage(widget.file);
  }
}

class FacePainter extends CustomPainter {
  late ui.Image image;
  late List<Face> faces;
  final List<Rect> rects = [];

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
}*/





/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

// ignore: camel_case_types
class readMeater extends StatefulWidget {
  const readMeater({Key? key}) : super(key: key);

  @override
  _readMeaterState createState() => _readMeaterState();
}

// ignore: camel_case_types
class _readMeaterState extends State<readMeater> {
  String imagePath = "asd";
  late File myImagePath;
  String finalText = ' ';
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: Colors.teal,
              child: isLoaded
                  ? Image.file(
                      myImagePath,
                      fit: BoxFit.fill,
                    )
                  :const Text("This is image section "),
            ),
            Center(
                child: TextButton(
                    onPressed: () {
                      getImage();

                      Future.delayed(const Duration(seconds: 10), () {
                        getText(imagePath);
                      });
                    },
                    child: Text(
                      "Pick Image",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 30,
                      ),
                    ))),
            Text(
              (finalText != " ") ? finalText : "This is my text",
              style: GoogleFonts.aBeeZee(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

Future getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText _reconizedText =
        await textDetector.processImage(inputImage);

    for (TextBlock block in _reconizedText.blocks) {
      for (TextLine textLine in block.lines) {
        for (TextElement textElement in textLine.elements) {
          setState(() {
            finalText = finalText + " " + textElement.text;
          });
        }

        finalText = finalText + '\n';
      }
    }
  }

  // this is for getting the image form the gallery
  void getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      myImagePath = File(image!.path);
      isLoaded = true;
      imagePath = image.path.toString();
    });
  }
}





/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'face_detection.dart';

class FaceDetectorHome extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _FaceDetectorHomeState();
}

class _FaceDetectorHomeState extends State<FaceDetectorHome> {
  late File image;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Face Detection'),
        ),
        body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildRowTitle(context, 'Pick Image'),
                buildSelectImageRowWidget(context)
              ],
            )
        )
    );
  }

  Widget buildRowTitle(BuildContext context, String title) {
    return Center(
        child: Padding(
          padding:const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1,
          ),
        )
    );
  }

  Widget buildSelectImageRowWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        createButton('Camera'),
        createButton('Gallery')
      ],
    );
  }

  Widget createButton(String imgSource) {
    return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child:RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: () {
                onPickImageSelected(imgSource);
              },
              child: Text(imgSource)),
        )
    );
  }


  onPickImageSelected(String imgSource) async {
    ImageSource src;
    if(imgSource == 'Gallery') {
      src = ImageSource.gallery;
    } else {
      src = ImageSource.camera;
    }

    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: src);
    File imgFile = File(image!.path);
    //if(imgFile==null)
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FaceDetection(imgFile)),
    );
  }
}*/*/