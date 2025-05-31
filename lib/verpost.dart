import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final String imagePath;
  final String bookName;
  final String publishDate;
  final String author;
  final String postedBy;

  const PostScreen({
    super.key,
    required this.imagePath,
    required this.bookName,
    required this.publishDate,
    required this.author,
    required this.postedBy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF737B64), // ✅ Fondo general
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'BOOKLY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 367,
          height: 622,
          decoration: BoxDecoration(
            color: const Color(
              0x1FD9D9D9,
            ), // ✅ Segundo fondo (gris muy transparente)
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imagePath,
                  width: 290,
                  height: 435,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 290,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(
                    0x99D9D9D9,
                  ), // ✅ Gris claro semitransparente (60%)
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      ' $bookName',
                      textAlign: TextAlign.center, // ✅ centrado
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ' $publishDate',
                      textAlign: TextAlign.center, // ✅ centrado
                    ),
                    Text(
                      ' $author',
                      textAlign: TextAlign.center, // ✅ centrado
                    ),
                    Text(
                      ' $postedBy',
                      textAlign: TextAlign.center, // ✅ centrado
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
