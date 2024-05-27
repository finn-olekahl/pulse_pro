import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/oss_licenses.dart';

class LicensesView extends StatelessWidget {
  const LicensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Licences'),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: allDependencies.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 23, 23, 23),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () => context.go(
                    '/licenses/details?title=${allDependencies[index].name[0].toUpperCase() + allDependencies[index].name.substring(1)}&license=${allDependencies[index].license!}'),
                //capitalize the first letter of the string
                title: Text(
                  allDependencies[index].name[0].toUpperCase() + allDependencies[index].name.substring(1),
                ),
                subtitle: Text(allDependencies[index].description),
              ),
            ),
          );
        },
      ),
    );
  }
}