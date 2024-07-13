// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:teach_app/core/custom_snackbar.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';
import 'package:teach_app/models/learn_by_self_model.dart';
import 'package:teach_app/repositories/user_repository.dart';
import 'package:teach_app/routers.dart';
import 'package:teach_app/service/firebase_service.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({
    super.key,
    required this.model,
    required this.nativeLanguage,
  });
  final WordByUserModel model;
  final String nativeLanguage;

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<DrawingLine> lines = [];
  List<List<DrawingLine>> undoStack = [];
  List<List<DrawingLine>> redoStack = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  final GlobalKey _globalKey = GlobalKey();
  late final WordByUserModel model;

  Future<bool> _save() async {
    final service = context.read<FirebaseService>();
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final String? saveAndGetUrl =
        await service.saveWordImage(pngBytes: pngBytes, model: model, nativeLanguage: widget.nativeLanguage);
    if (saveAndGetUrl != null) {
      model.wordImageUrl = saveAndGetUrl;
      final saveWord = await service.saveLearningWord(model, widget.nativeLanguage);
      if (saveWord && mounted) {
        context.read<UserRepository>().user?.learningWord?.add(model);
        return saveWord;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  void _undo() {
    if (lines.isNotEmpty) {
      setState(() {
        redoStack.add(List.from(lines));
        lines = undoStack.isNotEmpty ? undoStack.removeLast() : [];
      });
    }
  }

  void _redo() {
    if (redoStack.isNotEmpty) {
      setState(() {
        undoStack.add(List.from(lines));
        lines = redoStack.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                lines.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _redo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  undoStack.add(List.from(lines));
                  lines.add(DrawingLine([details.localPosition], selectedColor, strokeWidth));
                  redoStack.clear();
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  lines.last.points.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  lines.last.points.add(Offset.zero);
                });
              },
              child: RepaintBoundary(
                key: _globalKey,
                child: CustomPaint(
                  painter: DrawingPainter(lines),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: PaddingConstant.paddingAll,
            color: Colors.white,
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  _textSpan(text: "Mükemmel! Şimdi "),
                  _textSpan(
                      text: "${model.nativeWord?.toUpperCase()} ",
                      style: context.textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                  _textSpan(text: "kelimesini sana hatırlatacak bir resim çiz!"),
                ])),
          ),
          Container(
            decoration:
                const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey, width: 2))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.color_lens, color: selectedColor),
                  onPressed: () {
                    _pickColor();
                  },
                ),
                Slider(
                  value: strokeWidth,
                  min: 1.0,
                  max: 10.0,
                  activeColor: Colors.black,
                  onChanged: (value) {
                    setState(() {
                      strokeWidth = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: PaddingConstant.paddingVertical,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final save = await _save();
                    if (save && context.mounted) {
                      customSnackBar(context: context, title: "${model.nativeWord} kelimesi kaydedildi!", isNegative: false);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Routers()));
                    } else {
                      customSnackBar(context: context, title: "Bir şeyler ters gitti :/", isNegative: true);
                    }
                  },
                  child: const Text("Kaydet"),
                ),
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
                  onPressed: () {},
                  child: const Text("İptal Et"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  TextSpan _textSpan({required String text, TextStyle? style}) =>
      TextSpan(text: text, style: style ?? const TextStyle(color: Colors.black));

  void _pickColor() async {
    Color? pickedColor = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renk Seç'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPickerWidget(
              onColorSelected: (color) {
                Navigator.pop(context, color);
              },
            ),
          ],
        ),
      ),
    );

    if (pickedColor != null) {
      setState(() {
        selectedColor = pickedColor;
      });
    }
  }
}

class DrawingLine {
  List<Offset> points;
  Color color;
  double strokeWidth;

  DrawingLine(this.points, this.color, this.strokeWidth);
}

class DrawingPainter extends CustomPainter {
  final List<DrawingLine> lines;

  DrawingPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      Paint paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = line.strokeWidth;

      for (int i = 0; i < line.points.length - 1; i++) {
        if (line.points[i] != Offset.zero && line.points[i + 1] != Offset.zero) {
          canvas.drawLine(line.points[i], line.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ColorPickerWidget extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorPickerWidget({super.key, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        _colorOption(Colors.black, context),
        _colorOption(Colors.red, context),
        _colorOption(Colors.green, context),
        _colorOption(Colors.blue, context),
        _colorOption(Colors.yellow, context),
      ],
    );
  }

  Widget _colorOption(Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onColorSelected(color);
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
