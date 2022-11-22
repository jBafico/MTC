import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool isReady = false;
  bool noCameraDevice = false;
  bool controllerInitialized = false;
  int selectedCamera = 0;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      cameras = await availableCameras();

      controller = CameraController(cameras[selectedCamera], ResolutionPreset.max);

      await controller.initialize();
      setState(() {
        controllerInitialized = true;
      });
    } on CameraException catch(_) {
      debugPrint("[CAMERA] HMMMMM");
    }

    if(!mounted) {
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

  @override
  Widget build(BuildContext context) {
    if(!controllerInitialized || !controller.value.isInitialized){
      return Container();
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }
}
