import 'dart:typed_data';

import 'package:area_expansion/area_expansion_create.dart';
import 'package:area_expansion/area_expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AreaExpansionDrag extends StatefulWidget {
  const AreaExpansionDrag({
    super.key,
    required this.call,
    required this.minimumValue,
    required this.trimFlg,
    required this.imagePath,
    required this.backColor,
    required this.rect,
    required this.child,
  });
  final Function(AreaExpansionCreate, Uint8List, Rect, String) call;
  final double minimumValue;
  final bool trimFlg;
  final String imagePath;
  final Color backColor;
  final Rect rect;
  final Widget child;
  @override
  State<AreaExpansionDrag> createState() => _AreaExpansionDragState();
}

class _AreaExpansionDragState extends State<AreaExpansionDrag> {
  double topHeight = 0;
  double bottomHeight = 0;
  double leftWidth = 0;
  double rightWidth = 0;
  @override
  void initState() {
    super.initState();
    topHeight = widget.rect.top;
    bottomHeight = widget.rect.bottom;
    leftWidth = widget.rect.left;
    rightWidth = widget.rect.right;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Top
            Positioned(
              top: 0,
              left: leftWidth,
              right: rightWidth,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    topHeight += details.delta.dy;
                    topHeight = topHeight.clamp(
                      widget.minimumValue,
                      constraints.maxHeight -
                          bottomHeight -
                          widget.minimumValue,
                    );
                  });
                },
                child: Container(color: widget.backColor, height: topHeight),
              ),
            ),

            // Left
            Positioned(
              top: topHeight,
              bottom: bottomHeight,
              left: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // Move width left
                    leftWidth += details.delta.dx;
                    // Minimum to left width
                    leftWidth = leftWidth.clamp(
                      widget.minimumValue,
                      constraints.maxWidth - rightWidth - widget.minimumValue,
                    );
                  });
                },
                child: Container(color: widget.backColor, width: leftWidth),
              ),
            ),

            // Right
            Positioned(
              top: topHeight,
              bottom: bottomHeight,
              right: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    rightWidth -= details.delta.dx;
                    rightWidth = rightWidth.clamp(
                      widget.minimumValue,
                      constraints.maxWidth - leftWidth - widget.minimumValue,
                    );
                  });
                },
                child: Container(color: widget.backColor, width: rightWidth),
              ),
            ),

            // Top Right
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    if (details.delta.dx > 0 && details.delta.dy < 0) {
                      // Right/Up direction drag - Expanding
                      rightWidth -= details.delta.dx;
                      topHeight += details.delta.dy;
                    } else if (details.delta.dx < 0 && details.delta.dy > 0) {
                      // Left/Down direction drag - Shrinking
                      rightWidth += details.delta.dx.abs();
                      topHeight += details.delta.dy.abs();
                    }
                    // Ensure that width and height stay within appropriate range
                    rightWidth = rightWidth.clamp(
                      widget.minimumValue,
                      constraints.maxWidth - leftWidth - widget.minimumValue,
                    );
                    topHeight = topHeight.clamp(
                      widget.minimumValue,
                      constraints.maxHeight -
                          bottomHeight -
                          widget.minimumValue,
                    );
                  });
                },
                child: Container(
                  color: widget.backColor,
                  width: rightWidth,
                  height: topHeight,
                ),
              ),
            ),

            /// Top Left
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    if (details.delta.dx < 0 && details.delta.dy < 0) {
                      // Left/Up direction drag - Expanding
                      leftWidth += details.delta.dx;
                      topHeight += details.delta.dy;
                    } else if (details.delta.dx > 0 && details.delta.dy > 0) {
                      // Right/Down direction drag - Shrinking
                      leftWidth += details.delta.dx.abs();
                      topHeight += details.delta.dy.abs();
                    }
                    // Ensure that width and height stay within appropriate range
                    leftWidth = leftWidth.clamp(
                      widget.minimumValue,
                      constraints.maxWidth - rightWidth - widget.minimumValue,
                    );
                    topHeight = topHeight.clamp(
                      widget.minimumValue,
                      constraints.maxHeight -
                          bottomHeight -
                          widget.minimumValue,
                    );
                  });
                },
                child: Container(
                  color: widget.backColor,
                  width: leftWidth,
                  height: topHeight,
                ),
              ),
            ),

            // Left Bottom
            Positioned(
              left: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    if (details.delta.dx < 0 && details.delta.dy > 0) {
                      // Left/Down direction drag - Expanding
                      leftWidth -= details.delta.dx.abs();
                      bottomHeight -= details.delta.dy;
                    } else if (details.delta.dx > 0 && details.delta.dy < 0) {
                      // Right/Up direction drag - Shrinking
                      leftWidth += details.delta.dx;
                      bottomHeight += details.delta.dy.abs();
                    }
                    // Ensure that width and height stay within appropriate range
                    leftWidth = leftWidth.clamp(
                      widget.minimumValue,
                      constraints.maxWidth - rightWidth - widget.minimumValue,
                    );
                    bottomHeight = bottomHeight.clamp(
                      widget.minimumValue,
                      constraints.maxHeight - topHeight - widget.minimumValue,
                    );
                  });
                },
                child: Container(
                  color: widget.backColor,
                  width: leftWidth,
                  height: bottomHeight,
                ),
              ),
            ),

            // Right Bottom
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    if (details.delta.dx > 0 && details.delta.dy > 0) {
                      // Right/Down direction drag - Expanding
                      rightWidth -= details.delta.dx;
                      bottomHeight -= details.delta.dy;
                    } else if (details.delta.dx < 0 && details.delta.dy < 0) {
                      // Left/Up direction drag - Shrinking
                      rightWidth += details.delta.dx.abs();
                      bottomHeight += details.delta.dy.abs();
                    }
                    // Ensure that width and height stay within appropriate range
                    rightWidth = rightWidth.clamp(
                      widget.minimumValue,
                      constraints.maxWidth - leftWidth - widget.minimumValue,
                    );
                    bottomHeight = bottomHeight.clamp(
                      widget.minimumValue,
                      constraints.maxHeight - topHeight - widget.minimumValue,
                    );
                  });
                },
                child: Container(
                  color: widget.backColor,
                  width: rightWidth,
                  height: bottomHeight,
                ),
              ),
            ),

            // Bottom
            Positioned(
              bottom: 0,
              left: leftWidth,
              right: rightWidth,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    bottomHeight -= details.delta.dy;
                    bottomHeight = bottomHeight.clamp(
                      widget.minimumValue,
                      constraints.maxHeight - topHeight - widget.minimumValue,
                    );
                  });
                },
                child: Container(color: widget.backColor, height: bottomHeight),
              ),
            ),

            // trim image
            AreaExpansionWidget(
              trimFlg: widget.trimFlg,
              imagePath: widget.imagePath,
              rect: Rect.fromLTRB(
                leftWidth,
                topHeight,
                rightWidth,
                bottomHeight,
              ),
              call: (p0, p1) async {
                var areaExpansionCreate = AreaExpansionCreate();

                var path = await areaExpansionCreate.createAndSaveCroppedImage(
                  p1,
                  p0,
                );
                widget.call(areaExpansionCreate, p0, p1, path);
              },
            ),

            // Center
            Positioned(
              top: topHeight,
              bottom: bottomHeight,
              left: leftWidth,
              right: rightWidth,
              child: widget.child,
            ),
          ],
        );
      },
    );
  }
}
