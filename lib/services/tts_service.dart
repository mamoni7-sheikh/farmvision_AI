// lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  // --------------------------------------------
  // INIT TTS FOR SELECTED LANGUAGE
  // --------------------------------------------
  Future<void> init(String lang) async {
    await _tts.setSpeechRate(0.45);     // Normal speed
    await _tts.setVolume(1.0);          // Full volume
    await _tts.setPitch(1.0);           // Natural tone

    if (lang == "hi") {
      // Hindi voice
      await _tts.setLanguage("hi-IN");
    } else {
      // English voice
      await _tts.setLanguage("en-US");
    }
  }

  // --------------------------------------------
  // SPEAK TEXT
  // --------------------------------------------
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    try {
      await _tts.stop();     // Stop previous speech
      await _tts.speak(text);
    } catch (e) {
      print("TTS ERROR → $e");
    }
  }

  // --------------------------------------------
  // DISPOSE
  // --------------------------------------------
  Future<void> dispose() async {
    await _tts.stop();
  }
}
