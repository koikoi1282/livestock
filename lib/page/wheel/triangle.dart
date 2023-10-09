import 'package:flutter/material.dart';

class Triangle extends StatelessWidget {
  const Triangle({
    Key? key,
    required this.size,
    this.color = Colors.white,
    this.radius = 0,
  }) : super(key: key);
  final Size size;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TriangleClipper(
        down: true,
        radius: radius,
      ),
      child: Container(
        color: color,
        width: size.width,
        height: size.height,
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  bool down;
  bool left;
  double radius;

  TriangleClipper({
    this.down = true,
    this.left = false,
    this.radius = 0,
  });

  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, 0.0);
    double x = radius;
    double y = radius;

    path.lineTo(size.width / 2 - (x / 2), (size.height - y));

    var firstControlPoint = Offset(size.width / 2, (size.height - (y / 2)));
    var firstEndPont = Offset(size.width / 2 + (x / 2), (size.height - y));
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPont.dx, firstEndPont.dy);
    path.lineTo(size.width / 2 + (x / 2), (size.height - y));
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
