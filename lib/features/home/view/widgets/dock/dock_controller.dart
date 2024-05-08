import 'package:flutter/foundation.dart';

class DockController extends ChangeNotifier {
  int currentIndex = 0;
  bool setCurrentIndex = false;

  int currentSliderIndex = 0;
  bool setCurrentSliderIndex = false;

  int size = 0;

  List<int> indexes = [];

  void jumpTo(int index) {
    setCurrentIndex = true;
    currentIndex = index;
    notifyListeners();
    setCurrentIndex = false;
  }

  void moveSliderTo(int index) {
    setCurrentSliderIndex = true;
    currentSliderIndex = index;
    notifyListeners();
    setCurrentSliderIndex = false;
  }
}