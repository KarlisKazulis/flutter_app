//when a user clicks on a specific GIF, they are presented with a detailed view of the GIF
//GifDefailScreen widget is responsible for this action

import 'package:flutter/material.dart';

class GifDetailScreen extends StatelessWidget {
  final String gifUrl;

  const GifDetailScreen({super.key, required this.gifUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GIF Detail')),
      body: Center(
        child: Image.network(gifUrl),
      ),
    );
  }
}
