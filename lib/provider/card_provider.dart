import 'package:flutter/cupertino.dart';

class CardProvider extends ChangeNotifier {
  final int _currentIndexNumber = 0;
  double _initial = 0.0;

  int get currentIndexNumber => _currentIndexNumber;
  double get initial => _initial;

  void updateToNext() {
    _initial = (_initial <= 1) ? ++_initial : 0;
    if (_initial > 1) {}
    // _currentIndexNumber = (_currentIndexNumber + 1 < quesAnsList.length)
    //     ? _currentIndexNumber + 1
    //     : 0;
    notifyListeners();
  }

  void updateToPrev() {
    _initial = (_initial - 0.1 >= 0) ? _initial - 0.1 : _initial;
    if (_initial < 0) {}
    // _currentIndexNumber = (_currentIndexNumber - 1 >= 0)
    //     ? _currentIndexNumber - 1
    //     : quesAnsList.length - 1;
    notifyListeners();
  }
}
