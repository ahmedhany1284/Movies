import 'dart:convert';
import 'package:http/http.dart' as http;

class Movie {
  final String name;
  final String imagePath;
  final String videoPath;
  final bool category;
  final int date;
  final Duration duration;
  final String description;

  const Movie({
    required this.name,
    required this.imagePath,
    required this.videoPath,
    required this.category,
    required this.date,
    required this.duration,
    required this.description,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['title'] ?? 'Unknown Title',
      imagePath: 'https://image.tmdb.org/t/p/w500${json['poster_path'] ?? ''}',
      videoPath: 'assets/coming_soon.mp4', // You can modify this according to your data
      category: (json['adult']),
      date: DateTime.tryParse(json['release_date'] ?? '')?.year ?? 0,
      duration: Duration(minutes: json['runtime'] ?? 0),
      description: json['overview'],
    );
  }

  static List<Movie> parseMovies(Map<String, dynamic> json) {
    final List<dynamic> results = json['results'] ?? [];
    return results.map((data) => Movie.fromJson(data)).toList();
  }



  static Future<Map<String, dynamic>> fetchMovies({int page = 1}) async {
    final String apiKey = '9813ce01a72ca1bd2ae25f091898b1c7';
    final String url =
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=$apiKey&page=$page';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<Movie> movies = parseMovies(responseData);
      final int currentPage = responseData['page'];
      final int totalPages = responseData['total_pages'];

      return {
        'movies': movies,
        'currentPage': currentPage,
        'totalPages': totalPages,
      };
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
