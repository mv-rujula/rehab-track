
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final cameras = await availableCameras();
    runApp(RehaTrackApp(cameras: cameras));
  } catch (e) {
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Unable to find a camera')),
      ),
    ));
  }
}

class RehaTrackApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const RehaTrackApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RehaTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: CameraScreen(cameras: cameras),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  String message = 'Starting camera...';

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  Future<void> startCamera() async {
    if (widget.cameras.isEmpty) {
      setState(() => message = 'No camera found');
      return;
    }

    try {
      final camera = widget.cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => widget.cameras.first,
      );

      final newController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await newController.initialize();

      if (!mounted) {
        await newController.dispose();
        return;
      }

      setState(() {
        controller = newController;
        message = 'Camera ready';
      });
    } catch (e) {
      if (mounted) {
        setState(() => message = 'Camera error: $e');
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraController = controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RehaTrack'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: cameraController != null &&
                cameraController.value.isInitialized
            ? Column(
                children: [
                  Expanded(
                    child: CameraPreview(cameraController),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Live camera preview',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              )
            : Text(message),
      ),
    );
  }
}
