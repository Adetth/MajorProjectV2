import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import 'api_service.dart';

class OCRPage extends StatefulWidget {
  final String imagePath;

  OCRPage({required this.imagePath});

  @override
  _OCRPageState createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  String extractedText = ""; // Holds the extracted text
  bool isLoading = true; // Tracks loading state
  bool showSummarizeButton = false; // Controls visibility of the Summarize button
  String evaluationResult = ""; // Holds the evaluation result from API

  @override
  void initState() {
    super.initState();
    extractTextFromImage(widget.imagePath);
  }

  // Function to extract text using Google ML Kit
  Future<void> extractTextFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    try {
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
      setState(() {
        extractedText = recognizedText.text;
        isLoading = false;
        showSummarizeButton = extractedText.isNotEmpty; // Enable the button if text is present
      });
    } catch (e) {
      setState(() {
        extractedText = "Failed to extract text. Error: $e";
        isLoading = false;
      });
    } finally {
      await textRecognizer.close();
    }
  }

// Function to summarize text by calling the API
  Future<void> summarizeText() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await ApiService.evaluateText(extractedText);
      setState(() {
        evaluationResult = result; // Store the API result
      });
    } catch (e) {
      setState(() {
        evaluationResult = "API Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Extraction & Summarization')),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loading spinner
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Extracted Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              extractedText,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            if (showSummarizeButton)
              ElevatedButton(
                onPressed: summarizeText,
                child: Text('Summarize'),
              ),
            if (evaluationResult.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Summarized Output:',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                evaluationResult,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
