import 'package:flutter/material.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/utils/image_utils.dart';

class GeneralBackground extends StatelessWidget {
  final bool onlyLogo;

  const GeneralBackground({super.key, this.onlyLogo = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onlyLogo)
          const Spacer()
        else ...[
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
        ],
        Image(
          image: imageMap['cargillLogo']!,
          width: 150,
        ),
      ],
    );
  }
}
