import 'package:flutter/material.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/utils/image_utils.dart';

class PurinaDialog extends StatelessWidget {
  final String name;
  final String price;

  const PurinaDialog({super.key, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(image: DecorationImage(image: imageMap['purinaDialog']!)),
          child: Center(
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '請回答出2個',
                      style: const TextStyle(fontSize: 24),
                      children: [
                        TextSpan(text: name, style: const TextStyle(color: primaryRed, fontSize: 36)),
                        const TextSpan(
                          text: '的產品特色，即可獲得',
                          style: TextStyle(fontSize: 24),
                        ),
                        TextSpan(text: price, style: const TextStyle(color: primaryRed, fontSize: 36)),
                        const TextSpan(
                          text: '!',
                          style: TextStyle(fontSize: 24),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(80, 80),
                          padding: EdgeInsets.zero,
                          elevation: 4,
                          shape: const CircleBorder(),
                          backgroundColor: primaryRed),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        '完成',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
