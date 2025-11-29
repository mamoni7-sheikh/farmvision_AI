// lib/services/translation_service.dart

import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  OnDeviceTranslator? _translator;
  final modelManager = OnDeviceTranslatorModelManager();

  bool _ready = false;

  // ----------------------------------------------------
  // INIT TRANSLATOR (English → Hindi)
  // ----------------------------------------------------
  Future<void> _init() async {
    if (_ready) return;

    // Download Hindi model if needed
    if (!await modelManager.isModelDownloaded(
      TranslateLanguage.hindi.bcpCode,
    )) {
      await modelManager.downloadModel(
        TranslateLanguage.hindi.bcpCode,
      );
    }

    _translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.hindi,
    );

    _ready = true;
  }

  // ----------------------------------------------------
  // TRANSLATE TEXT
  // ----------------------------------------------------
  Future<String> translate(String text) async {
    if (text.trim().isEmpty) return text;

    await _init();

    try {
      return await _translator!.translateText(text);
    } catch (e) {
      print("TRANSLATION ERROR → $e");
      return text;
    }
  }

  // ----------------------------------------------------
  // CLEANUP
  // ----------------------------------------------------
  void dispose() {
    _translator?.close();
  }
}
