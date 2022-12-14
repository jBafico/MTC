

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:maneja_tus_cuentas/Screens/new_movement.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late List<CameraDescription> cameras; // List of the devices cameras
  late CameraController controller;     // controller for the cameras
  bool isReady = false;                 //
  bool noCameraDevice = false;          //
  bool controllerInitialized = false;   // To check if the future was resolved
  int selectedCamera = 0;               // Back camera
  bool dialogOpen = false;              // Status of processing dialog

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      cameras = await availableCameras();

      controller =
          CameraController(cameras[selectedCamera], ResolutionPreset.max);

      await controller.initialize();
      setState(() {
        controllerInitialized = true;
      });
    } on CameraException catch (_) {
      debugPrint("[CAMERA] HMMMMM");
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isReady = true;
    });
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<XFile?> takePicture() async {
    final CameraController cameraController = controller;
    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      return null;
    }
  }


  Future<bool> analyseImage() async {
    showProgressIndicator();
    await controller.setFlashMode(FlashMode.off);
    XFile? rawImage = await takePicture();

    if (rawImage == null) {
      hideProgressIndicator();
      return false;
    }

    InputImage inputImage = InputImage.fromFilePath(rawImage.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    // Get text from image
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    double possibleTotal = 0;
    RegExp exp = RegExp("[0-9]+[,\.]{1}[0-9]{2}");

    for (TextBlock block in recognizedText.blocks) {
      debugPrint("[BLOCK]: ${block.text}");
      for (TextLine line in block.lines) {
        debugPrint("[LINE]: ${line.text}");
        for (TextElement element in line.elements) {
          debugPrint("[ELEMENT]: ${element.text}");
          // find the max double value in the ticket
          String? str = exp.stringMatch(element.text);
          if(str != null)  {
            debugPrint("[NUMBER]: $str");
            double? aux = double.tryParse(str.replaceAll(',', '.'));
            if(aux != null && possibleTotal < aux) {
              possibleTotal = aux;
            }
          }
        }
      }
    }

    hideProgressIndicator();
    if (mounted && possibleTotal != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewMovementScreen(
            initialValue: possibleTotal,
          ),
        ),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!controllerInitialized || !controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AspectRatio(
            aspectRatio: 1 / controller.value.aspectRatio,
            child: Stack(
              children: <Widget>[
                controller.buildPreview(),
                Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: InkWell(
                    onTap: () async {
                      await analyseImage();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: const [
                        Icon(Icons.circle, color: Colors.white38, size: 80),
                        Icon(Icons.circle, color: Colors.white, size: 65),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ]));
  }

  void showProgressIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    dialogOpen = true;
  }

  void hideProgressIndicator() {
    if(dialogOpen) {
      Navigator.of(context).pop();
    }
    dialogOpen = false;
  }
}

