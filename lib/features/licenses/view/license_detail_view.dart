import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LicenseDetailsView extends StatelessWidget {
  final String title, license;
  const LicenseDetailsView(
      {required this.title, required this.license, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.deepPurple.shade100,
        title: Text(title, style: const TextStyle(fontFamily: 'sansman')),
        leading: Center(
          child: GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.translucent,
            child: const FaIcon(FontAwesomeIcons.anglesLeft),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.deepPurple.shade100.withOpacity(0.075),
              borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  license,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.courierPrime().fontFamily,
                      color: Colors.deepPurple.shade100.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
