import 'package:flutter/material.dart';
import 'api_service.dart';

class ExtractedTextScreen extends StatelessWidget {
  final String extractedText;

  const ExtractedTextScreen({Key? key, required this.extractedText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Extracted Text"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Extracted Text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(extractedText.isEmpty ? 'No text extracted yet.' : extractedText),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Call summarization API
                ApiService apiService = ApiService();
                String summary = await ApiService.evaluateText(extractedText);

                // Navigate to summary screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(summary: summary),
                  ),
                );
              },
              child: Text('Summarize'),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final String summary;

  const SummaryScreen({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          summary.isEmpty ? 'No summary available.' : summary,
        ),
      ),
    );
  }
}
