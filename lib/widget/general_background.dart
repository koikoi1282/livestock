import 'package:flutter/material.dart';
import 'package:livestock/constants/color.dart';

class GeneralBackground extends StatelessWidget {
  const GeneralBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16)),
            color: darkGray,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              color: lightGray,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Image.asset(
          'assets/cargill_logo.png',
          width: 150,
          cacheWidth: 150,
        ),
      ],
    );
  }
}
