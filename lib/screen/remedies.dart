class RemediesData {
  static Map<String, Map<String, List<String>>> all = {
    "Healthy Leaf": {
      "Local Remedies": [
        "Leaf is healthy. No treatment needed.",
      ],
      "Preventive Measures": [
        "Maintain regular watering.",
        "Avoid over-fertilization."
      ]
    },

    "Leaf Blight": {
      "Local Remedies": [
        "Remove affected leaves.",
        "Ensure proper air circulation.",
      ],
      "Organic Treatment": [
        "Spray neem oil 3%.",
        "Use buttermilk spray weekly."
      ],
      "Chemical Treatment": [
        "Spray Mancozeb.",
        "Use Copper Oxychloride."
      ],
      "Preventive Measures": [
        "Avoid excess moisture.",
        "Use disease-free seeds."
      ]
    },

    "Leaf Spot": {
      "Local Remedies": [
        "Remove infected leaves.",
        "Keep surroundings dry."
      ],
      "Organic Treatment": [
        "Apply baking soda spray.",
        "Use garlic extract spray."
      ],
      "Chemical Treatment": [
        "Apply Chlorothalonil.",
      ],
      "Preventive Measures": [
        "Avoid overhead irrigation.",
        "Maintain plant spacing."
      ]
    },

    "Not Leaf": {
      "Local Remedies": [
        "This is not a leaf.",
        "Upload a clear leaf photo."
      ]
    }
  };

  static Map<String, List<String>> get(String disease) {
    return all[disease] ?? {};
  }
}
