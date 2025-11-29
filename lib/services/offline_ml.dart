import 'dart:io';
import 'dart:math';                      // <<< IMPORTANT
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class OfflineML {
  late Interpreter interpreter;
  bool isLoaded = false;

  final int inputSize = 224;
  final int numClasses = 38;

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('model/crop_model.tflite');
      interpreter.allocateTensors();
      isLoaded = true;
      print("✔ Offline TFLite model loaded");
    } catch (e) {
      print(" MODEL LOAD ERROR → $e");
    }
  }

  String cleanLabel(String raw) {
    return raw
        .replaceAll("___", " – ")
        .replaceAll("_", " ")
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();
  }

  // ---------------------------------------------------
  // SAFE SOFTMAX (using dart:math)
  // ---------------------------------------------------
  List<double> _softmax(List<double> logits) {
    double maxLogit = logits.reduce(max);

    List<double> expScores =
        logits.map((e) => exp(e - maxLogit)).toList();

    double sum = expScores.reduce((a, b) => a + b);

    return expScores.map((e) => e / sum).toList();
  }

  List<List<List<List<double>>>> _preprocess(File file) {
    final bytes = file.readAsBytesSync();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) throw Exception("IMAGE DECODING FAILED");

    final resized = img.copyResize(decoded,
        width: inputSize, height: inputSize);

    return [
      List.generate(inputSize, (y) {
        return List.generate(inputSize, (x) {
          final px = resized.getPixel(x, y);
          return [
            px.r / 255.0,
            px.g / 255.0,
            px.b / 255.0,
          ];
        });
      })
    ];
  }

  Future<Map<String, dynamic>> predict(
      File image, List<String> labels) async {
    if (!isLoaded) {
      return {"label": "Model not loaded", "confidence": 0.0};
    }

    late List<List<List<List<double>>>> input;

    try {
      input = _preprocess(image);
    } catch (e) {
      print(" PREPROCESS ERROR → $e");
      return {"label": "Invalid Image", "confidence": 0.0};
    }

    final output = List.generate(1, (_) => List<double>.filled(numClasses, 0.0));

    try {
      interpreter.run(input, output);
    
    } catch (e) {
      print(" INTERPRETER ERROR → $e");
      return {"label": "Prediction failed", "confidence": 0.0};
    }

    List<double> scores = List<double>.from(output[0]);

    // Softmax
    scores = _softmax(scores);

    int maxIndex = 0;
    double maxValue = scores[0];

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxValue) {
        maxValue = scores[i];
        maxIndex = i;
      }
    }

    if (maxIndex >= labels.length) {
      print(" LABEL INDEX ERROR");
      return {"label": "Unknown", "confidence": maxValue};
    }

    return {
      "label": cleanLabel(labels[maxIndex]),
      "confidence": maxValue,
    };
  }
}
