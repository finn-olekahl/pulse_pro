import 'package:flutter/material.dart';

class EditDataButton extends StatelessWidget {
  const EditDataButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade500,
            foregroundColor: Colors.deepPurple.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => {},
          child: Text(
            'Edit Personal Data',
            style: TextStyle(
              color: Colors.deepPurple.shade100,
              fontSize: 15,
            ),
          )),
    );
  }
}
