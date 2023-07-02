import 'package:flutter/material.dart';
import 'package:area_expansion_example/image_screen.dart';
import 'package:area_expansion/area_expansion_drag.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _isClipped = true;
  final String _path = 'assets/exam.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AreaExpansion'),
      ),
      body: Stack(
        children: [
          if (_isClipped)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_path),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          AreaExpansionDrag(
            trimFlg: _isClipped,
            imagePath: _path,
            backColor: Colors.black.withOpacity(0.5),
            rect: const Rect.fromLTRB(100, 200, 100, 200),
            minimumValue: 5,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
            call: (p0, p1) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Navigate?'),
                  content: const Text(
                      'Do you want to navigate to the image screen?'),
                  actions: [
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _isClipped = true;
                        });
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.pop(context);
                        Future(() => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageScreen(
                                  imageBytes: p0,
                                  rect: p1,
                                ),
                              ),
                            )).then((_) {
                          setState(() {
                            _isClipped = true;
                          });
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          // Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isClipped = !_isClipped;
                  });
                },
                child: const Text('Expansion'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
