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
  double _zoomScale = 1.0; // ズームレベルを管理する変数
  final String _path = 'assets/exam.jpg';
  Offset _offset = Offset.zero; // 画像の位置を追跡するための変数
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
                Transform.translate(
                  offset: _offset, // 更新された位置に基づいて画像を移動
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                // パンジェスチャーを検出
                onPanUpdate: (details) {
                  setState(() {
                    _offset += details.delta; // 位置を更新
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
                      min: 1.0, // 最小ズームレベル
                      max: 5.0, // 最大ズームレベル
                      value: _zoomScale,
                      onChanged: (value) {
                        setState(() {
                          _zoomScale = value; // スライダーの値でズームレベルを更新
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
