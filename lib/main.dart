import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyImagePicker(),
      ),
    );
  }
}

class MyImagePicker extends StatefulWidget {
  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  double strokeWidth = 2.0;
  double cellWidth = 40;
  double cellHeight = 40;
  final _globalKey = GlobalKey(); // 添加 GlobalKey

  Future getImage() async {
    await _picker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        if (value != null) {
          _image = File(value.path);
        }
      });
    });
  }

  void updateStrokeWidth(double value) => setState(() => strokeWidth = value);

  void updateCellWidth(double value) => setState(() => cellWidth = value);

  void updateCellHeight(double value) => setState(() => cellHeight = value);

  Future<void> _saveImage() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    // 增加 pixelRatio 参数来提高截图质量
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(pngBytes);
    print('Image saved at $result');
  }


  @override
  Widget build(BuildContext context) {
    return _image == null
        ? Center(
      child: ElevatedButton(
        onPressed: getImage,
        child: Text('选择图片'),
      ),
    ) : Scaffold(
        body: Stack(
          children: [
            Center(
              child: RepaintBoundary(
                key: _globalKey,
                child: Stack(
                  children: [
                    // 原始图片和表格的部分
                    Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      height: 300,
                      width: 300,
                    ),
                    DraggableTable(
                      strokeWidth: strokeWidth,
                      cellWidth: cellWidth,
                      cellHeight: cellHeight,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Slider(
                value: strokeWidth,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: updateStrokeWidth,
                label: "线条粗细",
              ),
            ),
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Slider(
                value: cellWidth,
                min: 20,
                max: 100,
                divisions: 16,
                onChanged: updateCellWidth,
                label: "格子宽度",
              ),
            ),
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Slider(
                value: cellHeight,
                min: 20,
                max: 100,
                divisions: 16,
                onChanged: updateCellHeight,
                label: "格子高度",
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveImage,
          child: Icon(Icons.save),
        )
    );
  }
}

class DraggableTable extends StatefulWidget {
  final double strokeWidth;
  final double cellWidth;
  final double cellHeight;

  const DraggableTable({
    required this.strokeWidth,
    required this.cellWidth,
    required this.cellHeight,
  });

  @override
  _DraggableTableState createState() => _DraggableTableState();
}

class _DraggableTableState extends State<DraggableTable> {
  Offset position = Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => position += details.delta),
        child: CustomPaint(
          size: Size(widget.cellWidth * 5, widget.cellHeight * 5),
          painter: TablePainter(
            strokeWidth: widget.strokeWidth,
            cellWidth: widget.cellWidth,
            cellHeight: widget.cellHeight,
          ),
        ),
      ),
    );
  }
}

class TablePainter extends CustomPainter {
  final double strokeWidth;
  final double cellWidth;
  final double cellHeight;

  TablePainter({
    required this.strokeWidth,
    required this.cellWidth,
    required this.cellHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    int gridRows = 5;
    int gridCols = 5;

    for (int i = 0; i <= gridCols; i++) {
      double dx = i * cellWidth;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    for (int i = 0; i <= gridRows; i++) {
      double dy = i * cellHeight;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
