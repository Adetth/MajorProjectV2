import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiUrl = 'http://192.168.29.230:5000/summarize'; // Change to your Flask server URL

  // Method to call the Flask API for text evaluation
  static Future<String> evaluateText(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"text": text}), // Send text in JSON format
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["summary"] ?? "No evaluation provided";
      } else {
        throw Exception("Failed to evaluate text. Server responded with status code ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during API call: $e");
    }
  }
}
