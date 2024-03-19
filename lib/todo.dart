// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:barcode_widget/barcode_widget.dart';
//
// class ImageEditor extends StatelessWidget {
//   final Image image; // 传入的图片
//
//   ImageEditor({required this.image});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         image, // 底层是原图片
//
//         // 在图片上添加各种元素
//         Positioned(
//           child: Text(
//             '2023-10-04', // 添加日期
//             style: TextStyle(color: Colors.white),
//           ),
//           top: 10,
//           left: 10,
//         ),
//         Positioned(
//           child: QrImage( // 添加二维码
//             data: 'https://example.com',
//             version: QrVersions.auto,
//             size: 100.0,
//           ),
//           bottom: 10,
//           left: 10,
//         ),
//         Positioned(
//           child: BarcodeWidget( // 添加条形码
//             barcode: Barcode.code128(),
//             data: '1234567890',
//           ),
//           bottom: 10,
//           right: 10,
//         ),
//         CustomPaint(
//           painter: ShapesPainter(), // 自定义绘制图形和表格
//           child: Container(),
//         ),
//       ],
//     );
//   }
// }
//
// class ShapesPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke;
//
//     canvas.drawRect(Rect.fromLTWH(10, 10, 100, 100), paint); // 绘制图形
//     // 可以继续添加其他的图形、表格绘制代码
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
