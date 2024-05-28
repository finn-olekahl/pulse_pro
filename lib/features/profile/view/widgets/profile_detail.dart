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
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade300.withOpacity(0.175),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.deepPurple.shade100.withOpacity(0.25),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Transform.translate(
                offset: const Offset(3, 0),
                child: Transform(
                  transform: Matrix4.skewX(-0.15),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.deepPurple.shade100,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
