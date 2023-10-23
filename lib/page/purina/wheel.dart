import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/page/purina/purina_dialog.dart';
import 'package:livestock/utils/hover_extension.dart';
import 'package:livestock/utils/image_utils.dart';

const wheelRadius = 500.0;

class WheelComponent extends HookWidget {
  final List<WheelData> wheelDatas;
  final ui.Image wheelImage;
  final List<ui.Image> imageList;
  final void Function(int selectedIndex) onFinish;

  const WheelComponent(
      {super.key, required this.wheelDatas, required this.wheelImage, required this.imageList, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final ObjectRef<int?> selectedWheelData = useRef<int?>(null);
    final angle = useState<double>(0);
    final circleTime = useRef<int>(12);
    final priceResult = useState<double>(0);
    final angleController = useAnimationController(duration: const Duration(milliseconds: 3000));

    useEffect(() {
      final Animation<double> angleAnimation = CurvedAnimation(parent: angleController, curve: Curves.easeOutCirc);

      angleController
        ..addListener(() {
          if (context.mounted) {
            angle.value = angleAnimation.value * circleTime.value;
          }
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            showDialog(
              context: context,
              builder: (context) => PurinaDialog(
                  name: wheelDatas[selectedWheelData.value!].name, price: wheelDatas[selectedWheelData.value!].price),
            ).then((value) => onFinish(selectedWheelData.value!));
          }
        });

      return;
    }, []);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 500,
          height: 500,
          child: Transform.rotate(
            angle: angle.value * (pi * 2) - priceResult.value * 2 * pi,
            child: CustomPaint(
              size: const Size(wheelRadius, wheelRadius),
              painter: WheelPainter(wheelDatas: wheelDatas, wheelImage: wheelImage, imageList: imageList),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: GestureDetector(
            onTap: () {
              spin(selectedWheelData, angleController, priceResult);
            },
            child: Image(
              image: imageMap['purinaPointer']!,
              width: 100,
            ),
          ).showCursorOnHover,
        ),
      ],
    );
  }

  void spin(ObjectRef<int?> selectedWheelData, AnimationController angleController, ValueNotifier<double> priceResult) {
    selectedWheelData.value = Random().nextInt(wheelDatas.length);
    priceResult.value = (selectedWheelData.value! / wheelDatas.length) + _midTweenDouble;

    angleController.forward(from: 0);
  }

  double get _midTweenDouble {
    if (wheelDatas.isEmpty) {
      return 0;
    }
    double piTween = 1 / wheelDatas.length;
    double midTween = piTween / 2;
    return midTween;
  }
}

class WheelPainter extends CustomPainter {
  final List<WheelData> wheelDatas;
  final ui.Image wheelImage;
  final List<ui.Image> imageList;

  WheelPainter({required this.wheelDatas, required this.wheelImage, required this.imageList});

  @override
  void paint(Canvas canvas, Size size) {
    int wheelLength = wheelDatas.length;

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    double startAngles = 0;

    List<double> angles = List.generate(wheelLength, (index) => (2 * pi / wheelLength) * (index + 1));

    canvas.drawImageRect(
        wheelImage,
        Rect.fromLTWH(0, 0, wheelImage.width.toDouble(), wheelImage.height.toDouble()),
        Rect.fromCenter(
            center: Offset(
              size.width / 2,
              size.height / 2,
            ),
            width: 500,
            height: 500),
        paint);

    startAngles = 0;

    for (int i = 0; i < wheelLength; i++) {
      canvas.save();

      double acStartAngles = startAngles;
      double acTweenAngles = angles[i];
      double roaAngle = acStartAngles / 2 + acTweenAngles / 2;

      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(roaAngle);

      canvas.drawImageRect(
          imageList[i],
          Rect.fromLTWH(0, 0, imageList[i].width.toDouble(), imageList[i].height.toDouble()),
          Rect.fromCenter(
              center: Offset(0, -size.height / 2 + 100),
              width: 100,
              height: 100 * imageList[i].height.toDouble() / imageList[i].width.toDouble()),
          paint);

      canvas.restore();
      startAngles = angles[i];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
