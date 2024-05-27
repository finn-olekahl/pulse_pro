import 'package:flutter/material.dart';

class EditDataButton extends StatelessWidget {
  const EditDataButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade500,
            foregroundColor: Colors.deepPurple.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
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
