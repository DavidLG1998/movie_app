import 'package:flutter/material.dart';

class ItemReviewWidget extends StatelessWidget {
  final String author;
  final String content;

  const ItemReviewWidget({Key? key, required this.author, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff1E1F2E),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              author,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              content,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
