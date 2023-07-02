import 'package:flutter/widgets.dart';

class AreaExpansion extends CustomClipper<Path> {
  const AreaExpansion({
    required this.rect,
  });
  final Rect rect;

  @override
  Path getClip(Size size) {
    final path = Path();
    Rect fromLTRB = Rect.fromLTRB(
      rect.left,
      rect.top,
      size.width - rect.right,
      size.height - rect.bottom,
    );
    path.addRect(fromLTRB);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
