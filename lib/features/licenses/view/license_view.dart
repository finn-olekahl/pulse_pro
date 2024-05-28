import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pulse_pro/oss_licenses.dart';

class LicensesView extends StatelessWidget {
  const LicensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 8, 26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.deepPurple.shade100,
        title: const Text(
          'Licences',
          style: TextStyle(fontFamily: 'sansman'),
        ),
        leading: Center(
          child: GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.translucent,
            child: const FaIcon(FontAwesomeIcons.anglesLeft),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: allDependencies.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100.withOpacity(0.075),
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  onTap: () => context.push(
                      '/license?title=${allDependencies[index].name[0].toUpperCase() + allDependencies[index].name.substring(1)}&license=${allDependencies[index].license!}'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: Text(
                      allDependencies[index].name[0].toUpperCase() +
                          allDependencies[index].name.substring(1),
                      style: TextStyle(color: Colors.deepPurple.shade100),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      allDependencies[index].description,
                      style: TextStyle(
                          fontFamily: GoogleFonts.courierPrime().fontFamily,
                          fontSize: 12,
                          height: 1.2,
                          color: Colors.deepPurple.shade100.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
