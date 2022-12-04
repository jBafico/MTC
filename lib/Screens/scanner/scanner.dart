

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
                      XFile? rawImage = await takePicture();

                      if (rawImage == null) {
                        return;
                      }

                      InputImage inputImage =
                          InputImage.fromFilePath(rawImage.path);
                      final textRecognizer =
                          TextRecognizer(script: TextRecognitionScript.latin);

                      // Get text from image
                      final RecognizedText recognizedText =
                          await textRecognizer.processImage(inputImage);


                      bool found = false;
                      for (TextBlock block in recognizedText.blocks) {
                        for (TextLine line in block.lines) {
                          for (TextElement element in line.elements) {

                            if (element.text.contains("total") ||
                                element.text.contains("Total")) {
                              found = true;
                            }

                            if (found && double.tryParse(element.text.replaceAll(',', '.')) != null) {

                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewMovementScreen(
                                      initialValue: double.parse(element.text),
                                    ),
                                  ),
                                );
                              }

                              return;
                            }
                          }
                        }
                      }

                      /*TODO QUE HACER CON LA RAW IMAGE
                    File imageFile = File(rawImage.path);

                    int currentUnix = DateTime.now().millisecondsSinceEpoch;
                    final directory = await getApplicationDocumentsDirectory();
                    String fileFormat = imageFile.path.split('.').last;

                    await imageFile.copy(
                       '${directory.path}/$currentUnix.$fileFormat',
                    );

                   */
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
}

