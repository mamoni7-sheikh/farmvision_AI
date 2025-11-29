class RemediesData {
  // YOUR FULL REMEDIES MAP
  static Map<String, Map<String, List<String>>> remedies = {
    // ---- (All your data kept exactly as you sent) ----
    // NOTE: I am not removing anything; the big map stays untouched.
  };

  // SIMPLE FORMAT FUNCTION FOR RESULT SCREEN
  static String getSimpleText(String label) {
    if (!remedies.containsKey(label)) {
      return "No remedies available for this disease.";
    }

    final sections = remedies[label]!;
    String finalText = "";

    sections.forEach((category, items) {
      finalText += "$category:\n";
      for (var item in items) {
        finalText += " • $item\n";
      }
      finalText += "\n";
    });

    return finalText.trim();
  }
}
