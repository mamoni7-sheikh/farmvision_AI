# FarmVision_AI — AI-Based Plant Disease Detection App

FarmVision_AI is an AI-powered mobile application that detects plant leaf diseases instantly.
It uses a quantized TFLite model to classify 38 plant diseases and works fully offline.

# Features

1. Camera & Gallery Image Input

2. On-device ML Prediction (TFLite)

3. 38 Plant Disease Classes

4. Organic & Chemical Remedies

5. Prediction History (Offline)

5. Modern UI (Poppins, Splash Screen, Theme)

6. Fast & Offline (Rural Friendly)

# Technology Stack

1. Flutter

2. Dart

3. TensorFlow Lite (TFLite)

4. SharedPreferences

5. Material Design

6. Python (for model training):

  1. Used the PlantVillage dataset containing over 50,000 labeled leaf images across 38 plant disease classes (From Kaggle).

  2. Images were preprocessed by resizing to 224×224, normalizing pixel values, and applying augmentation for better learning.

  3. A CNN-based deep learning model was built using TensorFlow/Keras to classify plant diseases from leaf images.

  4. The model was trained and evaluated using train/validation/test splits to achieve high accuracy and good generalization.

  5. The final model was optimized and converted to TFLite (int8) for fast, offline inference inside the Flutter app.


FarmVision_AI – Project Workflow & Structure
FarmVision_AI/
│
├── lib/
│   ├── main.dart
│   │
│   ├── screens/
│   │   ├── home.dart
│   │   ├── photo_picker.dart
│   │   ├── result.dart
│   │   ├── remedies.dart
│   │   └── history.dart
│   │
│   ├── ml/
│   │   ├── ml_service.dart
│   │   ├── image_preprocessor.dart
│   │   ├── labels_loader.dart
│   │   └── history_service.dart
│
├── assets/
│   ├── splash/
│   │   └── logo.png
│   │
│   ├── fonts/
│   │   ├── Poppins-Regular.ttf
│   │   ├── Poppins-Medium.ttf
│   │   └── Poppins-Bold.ttf
│   │
│   └── model/
│       ├── crop_model_int8.tflite
│       └── labels.txt
│
├── pubspec.yaml
├── README.md
└── app-release.apk



# How It Works

1. User captures or uploads a leaf image

2. Image is preprocessed (224×224 RGB)

3. TFLite model predicts disease (int8 quantized model)

4. App displays:

5. Disease Name

6. Confidence %

7. Remedies

8. History saved in SharedPreferences

# Target Users

Farmers

Students

Agriculture officers

Gardeners

Rural communities

# Why FarmVision_AI?

No internet needed

Lightweight ML model

Instant offline results

Easy UI for non-technical users

Accurate predictions
