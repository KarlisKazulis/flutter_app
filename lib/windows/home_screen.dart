//main page of the app, shows the search bar and displays the grid widget once user starts typing
//was difficult to implement to the debounce feature aka the auto search -  when the GIFs change
//when user starts typing in the input field

import 'package:flutter/material.dart';
import 'package:gif_search_app/fetching/giphy_fetch.dart';
import 'package:gif_search_app/windows/gif_in_detail.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _gifs = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _offset = 0;
  String _query = '';
  ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  Future<void> _fetchGifs() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final newGifs = await GiphyService.fetchGifs(_query, _offset);
      setState(() {
        _gifs = _offset == 0 ? newGifs : [..._gifs, ...newGifs];
        _isLoading = false;
        _hasMore = newGifs.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _onScroll() {
    if (_hasMore && !_isLoading) {
      _offset += 20;
      _fetchGifs();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _onScroll();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GIF Search App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search for GIFs',
              ),
              onChanged: (query) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    _query = query;
                    _gifs.clear();
                    _offset = 0;
                    _hasError = false;
                    _errorMessage = '';
                  });
                  _fetchGifs();
                });
              },
            ),
            if (_hasError)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                controller: _scrollController,
                children: List.generate(_gifs.length + 1, (index) {
                  if (index == _gifs.length) {
                    return _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Container();
                  }

                  final gif = _gifs[index];
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
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
