import 'dart:io';
import 'package:flutter/material.dart';
import '../data/remedies_data.dart';

class ResultScreen extends StatelessWidget {
  final String disease;
  final double confidence;
  final String imagePath;
  final String lang;

  const ResultScreen({
    Key? key,
    required this.disease,
    required this.confidence,
    required this.imagePath,
    required this.lang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final confPercent = (confidence * 100).toStringAsFixed(1);

    // Get remedies from the optimized RemediesData
    final String remedyText = RemediesData.getSimpleText(disease);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction Result"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(imagePath),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Disease: $disease",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Confidence: $confPercent%",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              const Text(
                "Possible Remedies:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                remedyText,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Back"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
