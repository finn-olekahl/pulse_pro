import 'package:flutter/material.dart';

class LicenseDetailsView extends StatelessWidget {
  final String title, license;
  const LicenseDetailsView({required this.title, required this.license, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: const Color.fromARGB(221, 23, 23, 23), borderRadius: BorderRadius.circular(8)),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  license,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}