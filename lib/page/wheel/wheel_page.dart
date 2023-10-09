import 'package:flutter/material.dart';
import 'package:livestock/page/wheel/wheel.dart';

class WheelPage extends StatelessWidget {
  const WheelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Spin the wheel!'),
            SizedBox(height: 20),
            Wheel(),
          ],
        ),
      ),
    );
  }
}
