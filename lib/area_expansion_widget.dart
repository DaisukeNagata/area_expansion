import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:area_expansion/area_expansion.dart';

class AreaExpansionWidget extends StatefulWidget {
  const AreaExpansionWidget({
    super.key,
    required this.call,
    required this.trimFlg,
    required this.imagePath,
    required this.rect,
  });
  final Function(Uint8List, Rect) call;
  final bool trimFlg;
  final String imagePath;
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
    return RepaintBoundary(
      key: _globalKey,
      child: ClipPath(
        clipper: AreaExpansion(rect: widget.rect),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.imagePath),
              fit: BoxFit.cover,
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

    // original image size
    final Size imageSize = Size(
        deviceSize.width - (widget.rect.left + widget.rect.right),
        deviceSize.height - (widget.rect.top + widget.rect.bottom));

    // Calculate offset to move to center
    final Offset offset = Offset(
      (widget.rect.left).abs(),
      (widget.rect.top).abs(),
    );

    // Calculate the center coordinates of the image.
    Offset imageCenter = Offset(
        offset.dx + imageSize.width / 2, offset.dy + imageSize.height / 2);
    // Calculate the center coordinates of the device
    Offset deviceCenter = Offset(deviceSize.width / 2, deviceSize.height / 2);
    // Calculate an offset to move the image to the center of the device
    Offset moveToCenter = Offset(
        deviceCenter.dx - imageCenter.dx, deviceCenter.dy - imageCenter.dy);
    widget.call(
        pngBytes,
        Rect.fromLTWH(moveToCenter.dx, moveToCenter.dy, imageSize.width,
            imageSize.height));
  }
}
