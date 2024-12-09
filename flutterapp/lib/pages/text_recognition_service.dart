import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

class TextRecognitionService {
  Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      textRecognizer.close();
      return recognizedText.text; // Return extracted text
    } catch (e) {
      textRecognizer.close();
      rethrow; // Throw the error if something goes wrong
    }
  }
}
