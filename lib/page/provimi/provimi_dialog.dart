import 'package:flutter/material.dart';
import 'package:livestock/constants/color.dart';

class ProvimiDialog extends StatelessWidget {
  final bool isCorrect;
  final String price;

  const ProvimiDialog({super.key, required this.isCorrect, required this.price});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/provimi_dialog.jpeg'))),
        child: Center(
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? '回答正確\n恭喜獲得' : '回答錯誤',
                  style: const TextStyle(color: primaryBlue, fontSize: 24),
                ),
                Text(
                  isCorrect ? price : '',
                  style: const TextStyle(color: primaryGreen, fontSize: 36),
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(80, 80),
                        padding: EdgeInsets.zero,
                        elevation: 4,
                        shape: const CircleBorder(),
                        backgroundColor: primaryGreen),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      isCorrect ? '完成' : '再試\n一次',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
