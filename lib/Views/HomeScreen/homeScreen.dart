import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../Helper/helper.dart';
import '../../Provider/HelpingProvider/helpingProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // File? _image;

  // String _result = "";

  Future<void> _openCamera() async {
    final helpingProvider =
        Provider.of<HelpingProvider>(context, listen: false);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      helpingProvider.setIsLoading(true);
      final imageFile = File(pickedFile.path);
      // final imageFile = File("assets/test_image.jpeg");
      helpingProvider.setImage(imageFile);
      // setState(() {
      //   _image = imageFile;
      // });

      await classifyImage(imageFile, context);
    } else {
      print('No image selected.');
    }
  }

  @override
  void initState() {
    super.initState();
    loadModelAndLabels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF3E0),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                'CritterAI',
                style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Image.asset(
              'assets/sparkling_star.png',
              width: 35,
              height: 35,
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                child: Text(
                  "Discover Your Animal !",
                  style: GoogleFonts.splineSans(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InkWell(
                  onTap: () async {
                    // await classifyAssetImage('assets/images.jpeg', context);
                    _openCamera();
                  },
                  child: Consumer<HelpingProvider>(
                    builder: (context, helpingProvider, child) {
                      return Container(
                        width: 160,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xffFFF3E0),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: helpingProvider.getIsLoading
                                ? CircularProgressIndicator(
                                    color: Colors.orange,
                                  )
                                : Text(
                                    "Snap a Photo",
                                    style: GoogleFonts.splineSans(
                                        fontSize: 16,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold),
                                  )),
                      );
                    },
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Or pick an image from the",
                      style: GoogleFonts.splineSans(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: " Gallery",
                      style: GoogleFonts.splineSans(
                        fontSize: 14,
                        color: Colors.orange,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final helpingProvider = Provider.of<HelpingProvider>(
                              context,
                              listen: false);
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            helpingProvider.setIsLoading(true);
                            final imageFile = File(pickedFile.path);
                            // setState(() {
                            helpingProvider.setImage(imageFile);
                            // _image = imageFile;
                            // });
                            await classifyImage(imageFile, context);
                          }
                        },
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
