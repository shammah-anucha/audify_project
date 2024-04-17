import 'package:flutter/foundation.dart';

enum ConversionStatus { idle, converting, completed }

class ConversionModel extends ChangeNotifier {
  ConversionStatus _status = ConversionStatus.idle;

  ConversionStatus get status => _status;

  void startConverting() {
    _status = ConversionStatus.converting;
    notifyListeners();
  }

  void completeConverting() {
    _status = ConversionStatus.completed;
    notifyListeners();
  }
}
