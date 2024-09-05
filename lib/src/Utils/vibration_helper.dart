import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class VibrationHelper {
  late bool hasVibrator;
  late bool hasAmplitudeControl;
  late bool hasCustomVibrationsSupport;

  // Private constructor
  VibrationHelper._privateConstructor() {
    initVibration();
  }

  // Static instance
  static final VibrationHelper _instance =
      VibrationHelper._privateConstructor();

  // Factory constructor to return the singleton instance
  factory VibrationHelper() {
    return _instance;
  }

  // Method to trigger vibration
  Future<void> vibrate({
    int duration = 100,
    bool vibrate = true,
    List<int> pattern = const [],
    int repeat = -1,
    List<int> intensities = const [],
    int amplitude = -1,
  }) async {
    try {
      if (vibrate &&
          hasVibrator &&
          hasCustomVibrationsSupport) {
        await Vibration.vibrate(
          duration: duration,
          intensities: intensities,
          pattern: pattern,
          repeat: repeat,
        );
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to vibrate: ${e.message}");
    }
  }

  void initVibration() async {
    hasVibrator = await Vibration.hasVibrator() ?? false;
    hasAmplitudeControl = await Vibration.hasAmplitudeControl() ?? false;
    hasCustomVibrationsSupport =
        await Vibration.hasCustomVibrationsSupport() ?? false;
  }
}
