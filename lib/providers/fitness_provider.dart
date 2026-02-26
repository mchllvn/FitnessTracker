import 'package:flutter/material.dart';
import '../models/fitness_model.dart';

class FitnessProvider extends ChangeNotifier {
  final List<FitnessData> _steps = [];
  final List<FitnessData> _water = [];

  List<FitnessData> get steps => _steps;
  List<FitnessData> get water => _water;

  bool addSteps(DateTime date, double value) {
    if (_steps.any((e) => _sameDate(e.date, date))) return false;
    _steps.add(FitnessData(date: date, value: value));
    notifyListeners();
    return true;
  }

  bool updateSteps(DateTime date, double value) {
    try {
      final item = _steps.firstWhere((e) => _sameDate(e.date, date));
      item.value = value;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void deleteSteps(DateTime date) {
    _steps.removeWhere((e) => _sameDate(e.date, date));
    notifyListeners();
  }

  bool addWater(DateTime date, double value) {
    if (_water.any((e) => _sameDate(e.date, date))) return false;
    _water.add(FitnessData(date: date, value: value));
    notifyListeners();
    return true;
  }

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  int totalSteps() => _steps.fold(0, (p, e) => p + e.value.toInt());

  double totalWater() => _water.fold(0, (p, e) => p + e.value);

  String stepCategory(double v) {
    if (v < 4000) return "Bad";
    if (v <= 8000) return "Average";
    return "Good";
  }

  String waterCategory(double v) {
    if (v < 1.5) return "Bad";
    if (v <= 2) return "Average";
    return "Good";
  }
}