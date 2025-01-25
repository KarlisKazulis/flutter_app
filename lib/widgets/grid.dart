//responsible for the GifGrid widget, displays GIFs in a grid format.
//Chose to display them in two columns for faster loading and better visibility.
//Using GridView.builder to build the grid, automatic pagination when user scrolls down
//also implemented a progress indicator to show that its loading more GIFs.

import 'package:flutter/material.dart';
import '../windows/gif_in_detail.dart';

class GifGrid extends StatelessWidget {
  final List gifs;
  final bool isLoading;
  final VoidCallback onLoadMore;

  const GifGrid({
    super.key,
    required this.gifs,
    required this.isLoading,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          onLoadMore();
        }
        return false;
      },
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: gifs.length,
              itemBuilder: (context, index) {
                final gif = gifs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GifDetailScreen(
                          gifUrl: gif['images']['original']['url'],
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    gif['images']['preview_gif']['url'],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
