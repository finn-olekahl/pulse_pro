import 'package:flutter/material.dart';
import 'package:pulse_pro/shared/models/split_day.dart';

class SplitDayCard extends StatelessWidget {
  const SplitDayCard({super.key, required this.splitDay});

  final SplitDay splitDay;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: IntrinsicHeight(
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2.0,
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              1.0,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _getTargetText(),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(50.0))),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(50.0))),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.stop,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text('Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                      Spacer(),
                      Text('00:11:00', style: TextStyle(fontSize: 18.0))
                    ],
                  ),
                  const Row(
                    children: [
                      Text('Rest', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                      Spacer(),
                      Text('00:00:30', style: TextStyle(fontSize: 16.0))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text _getTargetText() {
    if (splitDay.restDay) return const Text('Rest Day');
    return Text(
      splitDay.target!.map((entry) {
        String str = entry.toString().split('.').last;
        return '${str[0].toUpperCase()}${str.substring(1)}';
      }).join(' & '),
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
    );
  }
}
