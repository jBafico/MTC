

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
    if(!controllerInitialized || !controller.value.isInitialized){
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        AspectRatio(
            aspectRatio: 1/controller.value.aspectRatio,
            child: Stack(
              children: <Widget>[
            controller.buildPreview(),
            Container(
              alignment: AlignmentDirectional.bottomCenter,
                child:
                  InkWell(
                    onTap: () async {
                    XFile? rawImage = await takePicture();
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
                )
                ,)

        ],
      ),
    )]
    )
    );

  }
}

