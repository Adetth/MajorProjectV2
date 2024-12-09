import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import camera package
import 'dart:io';
import 'text_recognition_service.dart';
import 'extracted_text_screen.dart';

class HomeScreen extends StatefulWidget {@override
_HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );_initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndExtractText() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller!.takePicture();

      // Extract text from the captured image
      TextRecognitionService textRecognitionService = TextRecognitionService();
      String extractedText = await textRecognitionService.extractTextFromImage(File(image.path));

      // Navigate to the extracted text screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExtractedTextScreen(extractedText: extractedText),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image to Text Summarizer"),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndExtractText,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}