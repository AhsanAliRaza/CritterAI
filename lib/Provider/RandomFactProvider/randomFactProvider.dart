import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class RandomFactProvider extends ChangeNotifier {
  String apiKey = "qDnJnlpwCwyGZLFFGqIF3P2Hm8VpbgLvy6oV01Yb";
  String name = "";
  String randomFact = "";
  bool isLoading = false;

  String get getName => name;
  bool get getIsLoading => isLoading;
  String get getRandomFact => randomFact;

  void setName(value) {
    name = value;
    notifyListeners();
  }

  void setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  void setRandomFact(value) {
    randomFact = value;
    notifyListeners();
  }

  /// Set loading state and notify listeners
  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  /// Check if device has internet connection
  Future<bool> _checkInternetConnection() async {
    try {
      final response = await get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> fetchRandomFact(BuildContext context) async {
  //   print("Fetching Random Fact");
  //   // Reset error message
  //   // _setErrorMessage(null);
  //
  //   // Set loading state
  //   _setLoading(true);
  //
  //   try {
  //     // Check internet connection first
  //     final hasInternet = await _checkInternetConnection();
  //     if (!hasInternet) {
  //       _setLoading(false);
  //       final message = 'No internet connection. Please check your network.';
  //       // _setErrorMessage(message);
  //       // FlushBarComponent(message: message).showFlushBar(context);
  //       return false;
  //     }
  //
  //     // Validate input fields
  //     // if (email.isEmpty || password.isEmpty) {
  //     //   _setLoading(false);
  //     //   final message = 'Please fill in all required fields.';
  //     //   _setErrorMessage(message);
  //     //   FlushBarComponent(message: message).showFlushBar(context);
  //     //   return false;
  //     // }
  //
  //     // Log log in attempt (but don't log password)
  //     // debugPrint(
  //     //     'Attempting login for: $email, password: $password, device token: $deviceToken, platform name: $platformName, timezone: $timezone');
  //
  //     // Set request timeout
  //     final response = await post(
  //       Uri.parse('https://api.cohere.ai/v1/generate'),
  //       body: jsonEncode({
  //         "model": "command-a-03-2025",
  //         "prompt": "Give me a random fact about cats for about 20 to 30 words",
  //         "max_tokens": 50
  //       }),
  //       headers: {
  //         'Authorization': 'Bearer $apiKey',
  //         'Content-Type': 'application/json'
  //       },
  //     ).timeout(
  //       const Duration(seconds: 15),
  //       onTimeout: () {
  //         return Response('Request timeout', 408);
  //       },
  //     );
  //
  //     // Parse response body safely
  //     Map<String, dynamic> data = {};
  //     if (response.body.isNotEmpty) {
  //       try {
  //         data = jsonDecode(response.body);
  //       } catch (e) {
  //         debugPrint('Failed to parse response: ${e.toString()}');
  //         // Continue with empty data map
  //       }
  //     }
  //     print("data: ${data}");
  //     if (response.statusCode == 200) {
  //       // Check success code from the API response
  //       if (data["code"] == 200) {
  //         // Success case
  //         _setLoading(false);
  //         final successMessage = data["message"] ?? 'Login successful!';
  //         // FlushBarComponent(message: successMessage).showFlushBar(context);
  //
  //         // Reset error message
  //         // _setErrorMessage(null);
  //
  //         // You can navigate to login screen or automatically log user in here
  //         // Example: Navigator.pushReplacementNamed(context, '/login');
  //         // setSessionData("auth_token", data['data']['token']);
  //         // String? authToken = await getSessionData('auth_token');
  //         // print(data['data']['token']); // auth token
  //
  //         // Navigator.pushNamed(context, RoutesName.candleStickV2);
  //         // debugPrint('Login successful.');
  //         return true;
  //       } else if (data["code"] == 422) {
  //         // Validation error cases
  //         _setLoading(false);
  //         // final errorMessage = _extractValidationErrorMessage(data);
  //         // _setErrorMessage(errorMessage);
  //         // FlushBarComponent(message: errorMessage).showFlushBar(context);
  //         return false;
  //       } else {
  //         // Other error codes from API
  //         _setLoading(false);
  //         // final errorMessage = data["message"] ?? 'Something went wrong';
  //         // _setErrorMessage(errorMessage);
  //         // FlushBarComponent(message: errorMessage).showFlushBar(context);
  //         return false;
  //       }
  //     } else if (response.statusCode == 408) {
  //       // Timeout case
  //       _setLoading(false);
  //       // const errorMessage = 'Request timed out. Please try again.';
  //       // _setErrorMessage(errorMessage);
  //       // const FlushBarComponent(message: errorMessage).showFlushBar(context);
  //       return false;
  //     } else {
  //       // Other HTTP error codes
  //       _setLoading(false);
  //       // final errorMessage =
  //       //     _getErrorMessageForStatusCode(response.statusCode, context);
  //       // _setErrorMessage(errorMessage);
  //       // FlushBarComponent(message: errorMessage).showFlushBar(context);
  //       debugPrint('HTTP Error: ${response.statusCode}');
  //       return false;
  //     }
  //   } catch (e) {
  //     // Handle exceptions
  //     _setLoading(false);
  //     // final errorMessage =
  //     //     'Error: ${e.toString().contains('SocketException') ? 'Network error' : 'Something went wrong'}';
  //     // _setErrorMessage(errorMessage);
  //     // FlushBarComponent(message: errorMessage).showFlushBar(context);
  //     debugPrint('Fetching Random Fact exception: ${e.toString()}');
  //     return false;
  //   }
  // }
}
