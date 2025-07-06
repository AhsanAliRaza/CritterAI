import 'package:flutter/material.dart';
import 'package:flutter_cohere/flutter_cohere.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wildai/Provider/HelpingProvider/helpingProvider.dart';

import '../../Provider/RandomFactProvider/randomFactProvider.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
        ),
        backgroundColor: const Color(0xffFFF3E0),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                'CritterAI Results',
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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffFFF3E0),
                Colors.white,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<HelpingProvider>(
                builder: (context, provider, child) {
                  return Card(
                    elevation: 8,
                    shadowColor: Colors.orange.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Color(0xffFFF9F0),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Animal name banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    provider.getResult == 'not_an_animal'
                                        ? ""
                                        : "I guess this is a...",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    provider.getResult == 'not_an_animal'
                                        ? "Well it ain't an animal"
                                        : provider.getResult,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Image with padding
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              height: 300,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    provider.getImage,
                                    fit: BoxFit.cover,
                                  )
                                  // : Image.asset(
                                  //     provider.getImage.path,
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  ),
                            ),
                          ),

                          // Result description
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "Wow! Look at this magnificent creature!",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Fun 'learn more' button
                          Consumer2<RandomFactProvider, HelpingProvider>(
                            builder: (context, randomFactProvider,
                                helpingProvider, child) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 20, right: 20, bottom: 10),
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // Check if the result is 'not_an_animal'
                                    if (helpingProvider.getResult
                                        .toLowerCase()
                                        .contains('not_an_animal')) {
                                      // Show a funny dialog for non-animal images
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Text(
                                              "Hmm, that's not quite right...",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  'assets/sparkling_star.png', // You might want to use a different image here
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                const SizedBox(height: 15),
                                                Text(
                                                  "My creature radar seems confused! I couldn't identify any animal in this image. Are you sure that's a critter and not a mysterious object?",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text(
                                                  "I'll Try Again!",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.orange,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }

                                    // Create a separate BuildContext for the loading dialog
                                    BuildContext? loadingDialogContext;

                                    // Show loading dialog
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext dialogContext) {
                                        // Store the loading dialog context
                                        loadingDialogContext = dialogContext;

                                        return Dialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(height: 10),
                                                const CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.orange),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  "Fetching animal facts...",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );

                                    var co = CohereClient(
                                        apiKey:
                                            'qDnJnlpwCwyGZLFFGqIF3P2Hm8VpbgLvy6oV01Yb');
                                    co
                                        .generate(
                                      prompt:
                                          "Give me a random fact about ${helpingProvider.getResult} for about 20 to 30 words just give me the fact nothing else",
                                    )
                                        .then((value) {
                                      // Close the loading dialog using its specific context
                                      if (loadingDialogContext != null) {
                                        Navigator.of(loadingDialogContext!)
                                            .pop();
                                      }

                                      final text =
                                          value['generations'][0]['text'];
                                      randomFactProvider
                                          .setRandomFact(text.toString());
                                      print("Cat fact: $text");

                                      // Show the facts dialog AFTER API call completes

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext factContext) {
                                          return AlertDialog(
                                            title: Text(
                                              "Creature Facts!",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  randomFactProvider
                                                      .getRandomFact,
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                const SizedBox(height: 15),
                                                Image.asset(
                                                  'assets/sparkling_star.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  // Use the fact dialog context to close only this dialog
                                                  Navigator.of(factContext)
                                                      .pop();
                                                },
                                                child: Text(
                                                  "Amazing!",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.orange,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          );
                                        },
                                      );
                                    }).catchError((e) {
                                      // Close the loading dialog using its specific context
                                      if (loadingDialogContext != null) {
                                        Navigator.of(loadingDialogContext!)
                                            .pop();
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(
                                                Icons.error_outline,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  'Could not fetch animal facts. Try again later!',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor:
                                              Colors.deepOrange.shade400,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          duration: const Duration(seconds: 3),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            textColor: Colors.white,
                                            onPressed: () {},
                                          ),
                                        ),
                                      );
                                      print(
                                          'Error fetching facts: ${e.toString()}');
                                    });
                                  },
                                  icon: const Icon(Icons.pets,
                                      color: Colors.orange),
                                  label: Text(
                                    "Tell me more about this critter!",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side:
                                        const BorderSide(color: Colors.orange),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Back button
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                                shadowColor: Colors.orange.withOpacity(0.5),
                              ),
                              child: Text(
                                "Classify Another Image",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
