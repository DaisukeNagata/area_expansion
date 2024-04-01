import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:area_expansion/area_expansion.dart';
import 'package:flutter/widgets.dart';

class AreaExpansionWidget extends StatefulWidget {
  const AreaExpansionWidget({
    super.key,
    required this.call,
    required this.trimFlg,
    required this.imagePath,
    required this.offset,
    required this.scale,
    required this.rect,
  });
  final Function(Uint8List) call;
  final bool trimFlg;
  final String imagePath;
  final Offset offset;
  final double scale;
  final Rect rect;

  @override
  State<AreaExpansionWidget> createState() => _RectClipperState();
}

class _RectClipperState extends State<AreaExpansionWidget> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void didUpdateWidget(AreaExpansionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trimFlg != widget.trimFlg && !widget.trimFlg) {
      Future(() async => await _capture(MediaQuery.of(context).size));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaledOffset = Offset(
      widget.offset.dx * widget.scale,
      widget.offset.dy * widget.scale,
    );
    return RepaintBoundary(
      key: _globalKey,
      child: Transform.translate(
        offset: scaledOffset,
        child: ClipPath(
          clipper: AreaExpansion(
            scale: widget.scale,
            offset: scaledOffset,
            rect: widget.rect,
          ),
          child: Transform.scale(
            alignment: Alignment.center,
            scale: widget.scale,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _capture(Size deviceSize) async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 1.0);

    // Convert the image to byte data
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    // Convert ByteData to Uint8List
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    widget.call(pngBytes);
  }
}
