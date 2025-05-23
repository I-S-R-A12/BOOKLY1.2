import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final String imagePath;
  final String bookName;
  final String publishDate;
  final String author;
  final String postedBy;

  const PostScreen({
    Key? key,
    required this.imagePath,
    required this.bookName,
    required this.publishDate,
    required this.author,
    required this.postedBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF90987C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'BOOKLY',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imagePath,
                  height: 200,
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📖 Nombre del libro: $bookName'),
                  Text('📅 Fecha de publicación: $publishDate'),
                  Text('✍ Autor: $author'),
                  Text('👤 Publicado por: $postedBy'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
