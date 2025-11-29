import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // System UI (status bar + navigation bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const FarmVisionApp());
}

class FarmVisionApp extends StatelessWidget {
  const FarmVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FarmVision AI",
      debugShowCheckedModeBanner: false,

      // Modern Material 3 theme
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,   // Better than primarySwatch
        scaffoldBackgroundColor: const Color(0xFFF4FFF4),
      ),

      home: const HomeScreen(),
    );
  }
}
