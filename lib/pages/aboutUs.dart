import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  AboutUs({super.key});
  final Uri _url = Uri.parse('https://jafarrezazadeh76@gmail.com');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(50),
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  ".برای انتقادات یا پیشنهادات لطفا به ایمیل زیر پیام دهید"),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () =>
                    launchUrl(_url, mode: LaunchMode.platformDefault),
                child: const Text("jafarrezazadeh76@gmail.com"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
