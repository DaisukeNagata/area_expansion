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
  final String _path = 'assets/exam.jpg';
  bool _isClipped = true;
  double _zoomScale = 1.0;
  Offset _offset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AreaExpansion'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              if (_isClipped)
                RepaintBoundary(
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: _zoomScale,
                    child: Transform.translate(
                      offset: _offset,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _offset += details.delta;
                  });
                },
                child: AreaExpansionDrag(
                  trimFlg: _isClipped,
                  imagePath: _path,
                  backColor: Colors.black.withOpacity(0.5),
                  offset: _offset,
                  rect: const Rect.fromLTRB(100, 200, 100, 200),
                  scale: _zoomScale,
                  minimumValue: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  call: (areaExpansionCreate, p0, path) {
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
                                        path: path,
                                        zoomScale: _zoomScale,
                                      ),
                                    ),
                                  )).then((_) async {
                                await areaExpansionCreate.clearImage();
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
              ),

              // Button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Slider(
                      min: 1.0, // min zoom down
                      max: 5.0, // max zoom up
                      value: _zoomScale,
                      onChanged: (value) {
                        setState(() {
                          _zoomScale = value;
                        });
                      },
                    ),
                    Align(
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
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
