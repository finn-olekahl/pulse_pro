import 'package:flutter/material.dart';

class ProfileDetail extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetail({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.deepPurple.shade100.withOpacity(0.65),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.deepPurple.shade100,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
