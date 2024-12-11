import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OMDb API Demo',
      home: MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OMDb Movie Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search Movies'),
              onSubmitted: (value) {
                _searchMovies(value);
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_movies[index].title),
                    subtitle: Text(_movies[index].annee),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchMovies(String query) async {
    const apiKey = '7b47b3c4';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&s=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> movies = data['Search'];

      setState(() {
        _movies = movies.map((movie) => Movie.fromJson(movie)).toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }
}


  class MovieDetailScreen extends StatefulWidget{
    @override
    _MovieDetailScreenState createState() => _MovieDetailScreenState();
  }

  class _MovieDetailScreenState {
    TextEditingController _textEditingController= TextEditingController();
    List<Movie> _movies = [];
  }

  class Detail{
    String title;
    String annee;
    String type;
    Image image;

    Detail({required this.title, required this.annee, required this.type, required this.image});
    factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      title: json['Title'],
      annee: json['Year'],
      type: json['Type'],
      image: json['Poster'],
    );

  }
}

class Movie{
  String title;
  String annee;

  Movie({required this.title, required this.annee});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      annee: json['Year'],
    );
  }
}