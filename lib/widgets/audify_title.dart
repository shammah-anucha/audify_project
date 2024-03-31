import 'package:flutter/material.dart';

class AudifyTitle extends StatelessWidget {
  const AudifyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(top: 100.0),
        color: Colors.white,
        child: const Text(
          'Audify',
          style: TextStyle(
              fontSize: 45, color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
