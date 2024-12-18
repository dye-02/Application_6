import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'OMDb API Demo',
      home: MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OMDb Movie Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Search Movies'),
              onSubmitted: (value) {
                _searchMovies(value);
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_movies[index].title),
                    subtitle: Text(_movies[index].annee),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => MovieDetailScreen(movie:_movies[index]))
                      );
                    },
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




class Movie{
  String title;
  String annee;
  String imdbid;

  Movie({required this.title, required this.annee, required this.imdbid});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      annee: json['Year'],
      imdbid: json['imdbID'],
    );
  }
}

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  //final TextEditingController _searchController = TextEditingController();
  late Map<String, dynamic>? _movieDetails;
  bool _isLoading = true;
  
  @override
  void initState(){
    super.initState();
    _getMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title ?? 'Details du film'),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _movieDetails == null
        ? Center(child: Text('Erreur de chargement'))
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
              child: Image.network(
                "${_movieDetails!['Poster']}",
                
                alignment: Alignment.center,
              ),),

              Center(
              child: Text(
              '${_movieDetails!['Title']}',
              style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold),
              ),),


              SizedBox(height: 10),
              Center(
              child: Text(
              'Année de sortie: ${_movieDetails!['Year']}',
                ),),
              

              Center(
              child:Text(
                'Genre: ${_movieDetails!['Genre']}',
                textAlign: TextAlign.center,
              ),),


              Center(
              child: Text(
                'Réalisateur: ${_movieDetails!['Director']}',
                textAlign: TextAlign.center,
              ),),


              Center(
              child: Text(
                'Résumé: ${_movieDetails!['Plot']}',
                textAlign: TextAlign.center,
              ),),


            ],
          ),
        ),
    );
}
  
  Future<void> _getMovie() async {
    const apiKey = '7b47b3c4';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&i=${widget.movie.imdbid}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        _movieDetails = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }
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