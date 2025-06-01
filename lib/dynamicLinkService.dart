import 'dart:async';
import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:deeplink/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DynamicLinkService {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;

  // Initialize app links
  static Future<void> initAppLinks() async {
    try {
      // Handle app launch from terminated state
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleIncomingLink(initialLink);
      }

      // Handle app links while app is running
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          _handleIncomingLink(uri);
        },
        onError: (err) {
          print('App Link Error: $err');
        },
      );
    } catch (e) {
      print('Failed to initialize app links: $e');
    }
  }

  // Handle incoming links
  static void _handleIncomingLink(Uri uri) {
    // Check if this is a RedirectMe dynamic link
    if (uri.host == 'app.redirectme.net') {
      print('RedirectMe dynamic link detected: $uri');
      // You can extract the link ID if needed: ${uri.pathSegments.first}
      // For now, navigate to home or a specific welcome screen
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
      return;
    }

    // Parse the URI and extract information for your app's deep links
    final String path = uri.path;
    final Map<String, String> queryParams = uri.queryParameters;

    // Navigate based on the link
    if (path.contains('/product')) {
      String? productId = queryParams['id'] ?? queryParams['productId'];
      if (productId != null) {
        navigatorKey.currentState?.pushNamed('/product', arguments: productId);
      }
    } else if (path.contains('/profile')) {
      String? userId = queryParams['userId'] ?? queryParams['id'];
      if (userId != null) {
        navigatorKey.currentState?.pushNamed('/profile', arguments: userId);
      }
    } else if (path.contains('/share')) {
      String? content = queryParams['content'];
      if (content != null) {
        navigatorKey.currentState?.pushNamed('/share', arguments: content);
      }
    } else {
      // Default navigation to home
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  // Create dynamic link via API call
  static Future<String?> createDynamicLink({
    required String deepLink,
    String? title,
    String? description,
    String? imageUrl,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      // Replace with your actual Dynamic Links API endpoint
      const String apiUrl = 'https://your-dynamic-links-api.com/create';

      final Map<String, dynamic> requestBody = {
        'deepLink': deepLink,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'androidPackageName': 'com.example.yourapp', // Your package name
        'iosPackageName': 'com.example.yourapp', // Your iOS bundle ID
        ...?additionalParams,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // Add any required API keys or authentication headers
          // 'Authorization': 'Bearer YOUR_API_KEY',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['shortLink'] ?? responseData['dynamicLink'];
      } else {
        print('Failed to create dynamic link: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating dynamic link: $e');
      return null;
    }
  }

  // Alternative: Create dynamic link with URL parameters (if your service supports it)
  static String createSimpleDynamicLink({
    required String baseUrl, // Your Dynamic Links domain
    required String deepLink,
    String? title,
    String? description,
    String? imageUrl,
  }) {
    final Uri uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'link': deepLink,
        if (title != null) 'st': title, // Social title
        if (description != null) 'sd': description, // Social description
        if (imageUrl != null) 'si': imageUrl, // Social image
        'apn': 'com.example.yourapp', // Android package name
        'ibi': 'com.example.yourapp', // iOS bundle ID
      },
    );

    return uri.toString();
  }

  // Dispose resources
  static void dispose() {
    _linkSubscription?.cancel();
  }
}
