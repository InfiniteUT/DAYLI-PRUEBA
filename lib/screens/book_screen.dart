import 'package:flutter/material.dart';
import '../models/book.dart';

class BookScreen extends StatelessWidget {
  final Book book;
  final VoidCallback onSave;

  const BookScreen({super.key, required this.book, required this.onSave});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController(text: book.content);

    void _saveContent() {
      book.content = _controller.text;
      onSave();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title, style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: NotebookPaperPainter(),
              ),
            ),
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Escribe aquí...',
                border: InputBorder.none,
              ),
              onChanged: (text) => _saveContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class NotebookPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.blue.shade200
      ..strokeWidth = 1;

    //final Paint marginPaint = Paint()
      //..color = Colors.red.shade300
      //..strokeWidth = 1;

    for (double y = 40; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    
    //canvas.drawLine(Offset(40, 0), Offset(40, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

