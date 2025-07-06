import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:wildai/Views/PredictedScreen/PredictionScreen.dart';

import '../Provider/HelpingProvider/helpingProvider.dart';
import '../Views/HomeScreen/homeScreen.dart';
import '../Views/PredictedScreen/PredictionScreen.dart';
import '../Views/ProfileScreen/profileScreen.dart';

List<Widget> buildScreens() {
  return [
    const HomeScreen(),
    const ProfileScreen(),
  ];
}

List<PersistentBottomNavBarItem> navBarsItems() {
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: ("Home"),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: CupertinoColors.systemGrey,
      scrollController: _scrollController1,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes: {
          "/first": (final context) => const HomeScreen(),
          "/second": (final context) => const ProfileScreen(),
        },
      ),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.settings),
      title: ("Settings"),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: CupertinoColors.systemGrey,
      scrollController: _scrollController2,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes: {
          "/first": (final context) => const HomeScreen(),
          "/second": (final context) => const ProfileScreen(),
        },
      ),
    ),
  ];
}

late Interpreter _interpreter;
late List<String> _labels;
///////////////////down test image
Future<Uint8List> loadAssetImage(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  return byteData.buffer.asUint8List();
}

Future<void> classifyAssetImage(String assetPath, BuildContext context) async {
  final helpingProvider = Provider.of<HelpingProvider>(context, listen: false);
  helpingProvider.setImage(File(assetPath));
  final bytes = await loadAssetImage(assetPath);
  final decodedImage = img.decodeImage(bytes);
  if (decodedImage == null) throw Exception("Failed to decode asset image");

  final inputTensor = prepareImage(decodedImage, 240);

  var input = inputTensor.reshape([1, 240, 240, 3]);
  var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

  _interpreter.run(input, output);

  final scores = output[0];
  int maxIndex = 0;
  double maxScore = scores[0];
  for (int i = 1; i < scores.length; i++) {
    if (scores[i] > maxScore) {
      maxScore = scores[i];
      maxIndex = i;
    }
  }

  // setState(() {
  //   _result =  "${_labels[maxIndex]} (${(maxScore * 100).toStringAsFixed(2)}%)";
  helpingProvider.setResult("${_labels[maxIndex]}");
  // _image = null; // since we're not displaying a File image here
  // });

  print("Asset image result: ${helpingProvider.getResult}");
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => const PredictionScreen()));
}

Float32List prepareImage(img.Image image, int inputSize) {
  img.Image resized =
      img.copyResize(image, width: inputSize, height: inputSize);

  Float32List input = Float32List(inputSize * inputSize * 3);
  int pixelIndex = 0;

  // For EfficientNet, we don't normalize by dividing by 255
  // This matches the Python implementation: im = image.img_to_array(im)
  for (int y = 0; y < inputSize; y++) {
    for (int x = 0; x < inputSize; x++) {
      final pixel = resized.getPixel(x, y);
      input[pixelIndex++] = pixel.r.toDouble();
      input[pixelIndex++] = pixel.g.toDouble();
      input[pixelIndex++] = pixel.b.toDouble();
    }
  }

  return input;
}
///////////////////up test image

Future<void> loadModelAndLabels() async {
  _interpreter =
      await Interpreter.fromAsset('assets/ai/AnimalClassification.tflite');
  final rawLabels = await rootBundle.loadString('assets/ai/labels.txt');
  _labels = rawLabels.split('\n').where((e) => e.trim().isNotEmpty).toList();
  print("Model & labels loaded. ${_labels.length} classes.");
}

Future<Float32List> imageToFloat32List(File imageFile, int inputSize) async {
  final bytes = await imageFile.readAsBytes();
  img.Image? image = img.decodeImage(bytes);
  if (image == null) throw Exception("Cannot decode image");

  img.Image resized =
      img.copyResize(image, width: inputSize, height: inputSize);

  Float32List input = Float32List(inputSize * inputSize * 3);
  int pixelIndex = 0;

  // For EfficientNet, we don't normalize by dividing by 255
  // This matches the Python implementation: im = image.img_to_array(im)
  for (int y = 0; y < inputSize; y++) {
    for (int x = 0; x < inputSize; x++) {
      final pixel = resized.getPixel(x, y);
      input[pixelIndex++] = pixel.r.toDouble();
      input[pixelIndex++] = pixel.g.toDouble();
      input[pixelIndex++] = pixel.b.toDouble();
    }
  }

  return input;
}

Future<void> classifyImage(File imageFile, BuildContext context) async {
  final helpingProvider = Provider.of<HelpingProvider>(context, listen: false);
  final inputTensor = await imageToFloat32List(imageFile, 240);

  var input = inputTensor.reshape([1, 240, 240, 3]);
  var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

  _interpreter.run(input, output);

  final scores = output[0];
  int maxIndex = 0;
  double maxScore = scores[0];
  for (int i = 1; i < scores.length; i++) {
    if (scores[i] > maxScore) {
      maxScore = scores[i];
      maxIndex = i;
    }
  }

  // Add top 3 scores for debugging
  List<MapEntry<String, double>> top3 = [];
  for (int i = 0; i < scores.length; i++) {
    if (top3.length < 3) {
      top3.add(MapEntry(_labels[i], scores[i]));
      top3.sort((a, b) => b.value.compareTo(a.value));
    } else if (scores[i] > top3.last.value) {
      top3.removeLast();
      top3.add(MapEntry(_labels[i], scores[i]));
      top3.sort((a, b) => b.value.compareTo(a.value));
    }
  }

  helpingProvider.setResult("${_labels[maxIndex]}");

  print("Top 3 predictions:");
  for (var entry in top3) {
    print("${entry.key}: ${(entry.value * 100).toStringAsFixed(2)}%");
  }

  print("This is the result: ${helpingProvider.getResult}");
  //here hide the loader
  helpingProvider.setIsLoading(false);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PredictionScreen(),
    ),
  );
}
