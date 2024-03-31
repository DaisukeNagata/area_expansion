import 'package:flutter/widgets.dart';

class AreaExpansion extends CustomClipper<Path> {
  const AreaExpansion({
    required this.offset,
    required this.rect,
  });
  final Offset offset;
  final Rect rect;

  @override
  Path getClip(Size size) {
    final path = Path();
    Rect fromLTRB = offset == Offset.zero
        ? Rect.fromLTRB(
            rect.left,
            rect.top,
            size.width - rect.right,
            size.height - rect.bottom,
          )
        : Rect.fromLTWH(
            rect.left - offset.dx,
            rect.top - offset.dy,
            rect.width,
            rect.height,
          );

    path.addRect(fromLTRB);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
