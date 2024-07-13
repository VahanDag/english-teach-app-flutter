// search_opponent_page.dart
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SearchOpponentPage extends StatefulWidget {
  const SearchOpponentPage({super.key});

  @override
  _SearchOpponentPageState createState() => _SearchOpponentPageState();
}

class _SearchOpponentPageState extends State<SearchOpponentPage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  bool isSearching = false;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? const Uuid().v4(); // Her kullanıcı için benzersiz olmalıdır

  void searchForOpponent() async {
    setState(() {
      isSearching = true;
    });

    DatabaseReference searchRef = databaseReference.child('searching_users').push();
    searchRef.set({'userId': userId, 'status': 'waiting'});

    databaseReference.child('searching_users').onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data['userId'] != userId && data['status'] == 'waiting') {
        String opponentId = data['userId'];
        searchRef.update({'status': 'matched', 'opponentId': opponentId});
        databaseReference
            .child('searching_users')
            .child(event.snapshot.key!)
            .update({'status': 'matched', 'opponentId': userId});

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DrawingPageTest(opponentId: opponentId, userId: userId)),
        );
      }
    });

    databaseReference.child('searching_users').onChildChanged.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data['userId'] == userId && data['status'] == 'matched') {
        String opponentId = data['opponentId'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DrawingPageTest(opponentId: opponentId, userId: userId)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Opponent'),
      ),
      body: Center(
        child: isSearching
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: searchForOpponent,
                child: const Text('Search for Opponent'),
              ),
      ),
    );
  }
}

// drawing_page.dart

class DrawingPageTest extends StatefulWidget {
  final String opponentId;
  final String userId;

  const DrawingPageTest({super.key, required this.opponentId, required this.userId});

  @override
  _DrawingPageTestState createState() => _DrawingPageTestState();
}

class _DrawingPageTestState extends State<DrawingPageTest> {
  final databaseReference = FirebaseDatabase.instance.ref();
  List<DrawingLine> lines = [];
  List<Offset> currentLinePoints = [];
  Timer? sendTimer;
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    listenForDrawingData();
    startSendTimer();
  }

  @override
  void dispose() {
    sendTimer?.cancel();
    super.dispose();
  }

  void startSendTimer() {
    sendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentLinePoints.isNotEmpty) {
        sendDrawingData();
      }
    });
  }

  void sendDrawingData() {
    if (currentLinePoints.isEmpty) return;

    List<Map<String, double>> drawingPoints = currentLinePoints.map((point) {
      return {'x': point.dx, 'y': point.dy};
    }).toList();

    databaseReference
        .child('drawings')
        .child(widget.userId)
        .push()
        .set({'points': drawingPoints, 'color': selectedColor.value, 'strokeWidth': strokeWidth}).then((_) {
      print('Drawing data sent successfully.');
      currentLinePoints.clear();
    }).catchError((error) {
      print('Failed to send drawing data: $error');
    });
  }

  void listenForDrawingData() {
    databaseReference.child('drawings').child(widget.opponentId).onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        try {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          final pointsData = data['points'] as List<dynamic>;
          List<Offset> points = pointsData.map((point) {
            return Offset(point['x'], point['y']);
          }).toList();
          DrawingLine line = DrawingLine(
            points,
            Color(data['color']),
            data['strokeWidth'].toDouble(),
          );
          setState(() {
            lines.add(line);
          });
        } catch (e) {
          print('Error processing drawing data: $e');
        }
      }
    }, onError: (error) {
      print('Failed to listen for drawing data: $error');
    });
  }

  void _undo() {
    if (lines.isNotEmpty) {
      setState(() {
        lines.removeLast();
      });
    }
  }

  void _redo() {
    // Redo fonksiyonu için ek bir yapı gerekebilir.
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
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  currentLinePoints = [details.localPosition];
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  currentLinePoints.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  lines.add(DrawingLine(currentLinePoints, selectedColor, strokeWidth));
                  currentLinePoints = [];
                });
                sendDrawingData();
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
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
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
          )
        ],
      ),
    );
  }

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
