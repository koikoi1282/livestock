import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livestock/page/wheel/triangle.dart';

const wheelRadius = 500.0;

class WheelComponent extends HookWidget {
  const WheelComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final angle = useState<double>(0);
    final circleTime = useRef<int>(12);
    final priceResult = useState<double>(0);
    final angleController = useAnimationController(duration: const Duration(milliseconds: 3000));

    useEffect(() {
      final Animation<double> angleAnimation = CurvedAnimation(parent: angleController, curve: Curves.easeOutCirc);

      angleController.addListener(() {
        if (context.mounted) {
          angle.value = angleAnimation.value * circleTime.value;
        }
      });

      return;
    }, []);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: angle.value * (pi * 2) - priceResult.value * 2 * pi,
              child: CustomPaint(
                size: const Size(wheelRadius, wheelRadius),
                painter: WheelPainter(),
              ),
            ),
            const Positioned(
              top: -3,
              child: Triangle(
                size: Size(30, 30),
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            // WheelData wheelData = spin(angleController, priceResult);
            // ExcelUtils.addNewColumn(
            //     ['name', 'email', 'phone', 'age', wheelData.wheelDataName]);
            // ExcelUtils.saveFile();
          },
          child: const Text('Spin'),
        )
      ],
    );
  }

  // WheelData spin(
  //     AnimationController angleController, ValueNotifier<double> priceResult) {
  //   int index = Random().nextInt(WheelData.values.length);
  //   priceResult.value = (index / WheelData.values.length) + _midTweenDouble;

  //   angleController.forward(from: 0);

  //   return WheelData.values[index];
  // }

  // double get _midTweenDouble {
  //   if (WheelData.values.isEmpty) {
  //     return 0;
  //   }
  //   double piTween = 1 / WheelData.values.length;
  //   double midTween = piTween / 2;
  //   return midTween;
  // }
}

class WheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // int wheelLength = WheelData.values.length;
    // List<Color> colors = [
    //   Colors.red,
    //   Colors.yellow,
    //   Colors.lightBlue,
    //   Colors.green,
    //   Colors.purple,
    //   Colors.pink
    // ];

    // Paint paint = Paint()
    //   ..color = Colors.red
    //   ..strokeWidth = 1.0
    //   ..isAntiAlias = true
    //   ..style = PaintingStyle.fill;

    // Rect rect = Rect.fromCircle(
    //   center: Offset(
    //     size.width / 2,
    //     size.height / 2,
    //   ),
    //   radius: size.width / 2,
    // );

    // double startAngles = 0;

    // List<double> angles = List.generate(
    //     wheelLength, (index) => (2 * pi / wheelLength) * (index + 1));

    // for (int i = 0; i < wheelLength; i++) {
    //   paint.color = colors[i];
    //   double acStartAngles = startAngles - (pi / 2);
    //   canvas.drawArc(rect, acStartAngles, angles[i] - startAngles, true, paint);
    //   startAngles = angles[i];
    // }

    // startAngles = 0;
    // for (int i = 0; i < wheelLength; i++) {
    //   canvas.save();

    //   double acStartAngles = startAngles - (pi / 2);
    //   double acTweenAngles = angles[i] - (pi / 2);
    //   double roaAngle = acStartAngles / 2 + acTweenAngles / 2 + pi;

    //   canvas.translate(size.width / 2, size.height / 2);
    //   canvas.rotate(roaAngle);

    //   TextSpan span = TextSpan(
    //     style: const TextStyle(
    //       color: Colors.white,
    //       fontSize: 24,
    //       fontWeight: FontWeight.bold,
    //     ),
    //     text: WheelData.values[i].wheelDataName,
    //   );

    //   TextPainter tp = TextPainter(
    //     text: span,
    //     textAlign: TextAlign.center,
    //     textDirection: TextDirection.ltr,
    //     textWidthBasis: TextWidthBasis.longestLine,
    //   );

    //   tp.layout(minWidth: size.width / 4, maxWidth: size.width / 4);
    //   tp.paint(canvas, Offset(-size.width / 2 + 20, 0 - (tp.height / 2)));

    //   canvas.restore();
    //   startAngles = angles[i];
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
