import 'package:deeplink/dynamicLinkService.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Links Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Method 1: Using API call
                String? link = await DynamicLinkService.createDynamicLink(
                  deepLink: 'https://yourapp.com/product?id=123',
                  title: 'Amazing Product',
                  description: 'Check out this amazing product!',
                  imageUrl: 'https://example.com/product-image.jpg',
                );

                if (link != null) {
                  print('Created dynamic link: $link');
                  // Share the link or copy to clipboard
                }
              },
              child: Text('Create Product Link (API)'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Method 2: Simple URL construction
                String link = DynamicLinkService.createSimpleDynamicLink(
                  baseUrl:
                      'https://yourproject.page.link', // Your Dynamic Links domain
                  deepLink: 'https://yourapp.com/profile?userId=456',
                  title: 'Check out my profile!',
                  description: 'Connect with me on our app',
                );

                print('Created simple link: $link');
                // Share the link
              },
              child: Text('Create Profile Link (Simple)'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: Text('Test Deep Link Navigation'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? productId =
        ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product ID: ${productId ?? 'Unknown'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Share this product
                String link = DynamicLinkService.createSimpleDynamicLink(
                  baseUrl: 'https://yourproject.page.link',
                  deepLink: 'https://yourapp.com/product?id=$productId',
                  title: 'Check out this product!',
                  description: 'Product #$productId',
                );
                print('Share link: $link');
              },
              child: Text('Share Product'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? userId =
        ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Center(child: Text('User ID: ${userId ?? 'Unknown'}')),
    );
  }
}

class ShareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? content =
        ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: Text('Shared Content')),
      body: Center(child: Text('Content: ${content ?? 'No content'}')),
    );
  }
}
