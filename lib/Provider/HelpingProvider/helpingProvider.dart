import 'dart:io';

import 'package:flutter/cupertino.dart';

class HelpingProvider extends ChangeNotifier {
  File? image;
  String result = '';
  bool isLoading = false;

  File get getImage => image!;
  String get getResult => result;
  bool get getIsLoading => isLoading;

  void setImage(File value) {
    image = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setResult(String value) {
    // if (value == "not_an_animal") {
    //   result = "";
    // } else {
    result = value;
    // }
    notifyListeners();
  }
}
