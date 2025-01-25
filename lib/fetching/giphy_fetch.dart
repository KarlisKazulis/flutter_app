//responsible for interacting with the gipfy API. GiphyServie class sends HTTP requests to Giphy
//to look for GIFs based on what the user has typed
//also added error management when status anything but 200 == OK.

import 'dart:convert';
import 'package:http/http.dart' as http;

const String giphyApiKey = 'bvRJD6UH3juAkhz5Ff08TYCOFvnI4oLH';

class GiphyService {
  static Future<List> fetchGifs(String query, int offset) async {
    try {
      String url =
          'https://api.giphy.com/v1/gifs/search?api_key=$giphyApiKey&q=$query&limit=20&offset=$offset';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception(
            'Failed to load GIFs. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching GIFs: $error');
    }
  }
}
