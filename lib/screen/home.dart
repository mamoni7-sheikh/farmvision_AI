import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history.dart';
import 'result.dart';
import 'photo_picker.dart';
import '../services/offline_ml.dart';
import '../services/network.dart';
import '../data/remedies_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  final OfflineML mlService = OfflineML();

  List<String> labels = [];
  bool modelLoaded = false;
  bool busy = false;
  bool showOfflineBanner = false;

  String prediction = "";
  double confidence = 0.0;
  String lang = "en";

  @override
  void initState() {
    super.initState();
    loadModel();
    listenNetwork();
  }

  // LOAD MODEL + LABELS
  Future<void> loadModel() async {
    try {
      await mlService.loadModel();

      final txt = await rootBundle.loadString("assets/model/labels.txt");
      labels = txt.split("\n").map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      setState(() => modelLoaded = true);
      debugPrint("MODEL READY — ${labels.length} labels loaded");
    } catch (e) {
      debugPrint("MODEL LOAD ERROR → $e");
    }
  }

  // NETWORK LISTENER
  void listenNetwork() {
    NetworkService.networkStatusStream().listen((isOnline) {
      if (!isOnline) {
        setState(() => showOfflineBanner = true);
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => showOfflineBanner = false);
        });
      } else {
        if (mounted) setState(() => showOfflineBanner = false);
      }
    });
  }

  // OPEN PHOTO PICKER
  Future<void> openPhotoPicker() async {
    if (!modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Model loading… please wait")),
      );
      return;
    }

    final File? img = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PhotoPickerScreen()),
    );

    if (img != null) {
      setState(() => _image = img);
      await runPrediction();
    }
  }

  // SAVE HISTORY (NO DEFICIENCY)
  Future<void> saveHistory(String label, double conf, String image) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("history") ?? [];

    final entry = {
      "label": label,
      "confidence": conf,
      "image": image,
      "time": DateTime.now().toIso8601String(),
    };

    history.add(jsonEncode(entry));

    if (history.length > 50) {
      history = history.sublist(history.length - 50);
    }

    await prefs.setStringList("history", history);
  }

  // RUN PREDICTION
  Future<void> runPrediction() async {
    if (_image == null || !modelLoaded) return;
    if (busy) return;

    setState(() => busy = true);

    try {
      final result = await mlService.predict(_image!, labels);
      final detectedLabel = result["label"];
      final conf = (result["confidence"] as num).toDouble();

      setState(() {
        prediction = detectedLabel;
        confidence = conf;
      });

      await saveHistory(detectedLabel, conf, _image!.path);

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            disease: detectedLabel,
            confidence: conf,
            imagePath: _image!.path,
            lang: lang,
          ),
        ),
      );

      if (mounted) {
        setState(() {
          _image = null;
          prediction = "";
          confidence = 0.0;
        });
      }
    } catch (e) {
      debugPrint("PREDICTION ERROR → $e");
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  // UI SMALL PREDICTION BOX
  Widget predictionBox() {
    if (busy) return const CircularProgressIndicator();
    if (prediction.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Text(
          "Prediction: $prediction",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          "Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FarmVision AI"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
          )
        ],
      ),

      body: Column(
        children: [
          if (showOfflineBanner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.red,
              child: const Text(
                "Offline – using local ML model",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.green.shade50,
                    ),
                    child: _image == null
                        ? const Center(child: Icon(Icons.image, size: 90, color: Colors.green))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                  ),

                  const SizedBox(height: 18),

                  ElevatedButton.icon(
                    onPressed: openPhotoPicker,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Select Image"),
                  ),

                  const SizedBox(height: 18),

                  predictionBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
