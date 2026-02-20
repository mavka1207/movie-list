import 'dart:convert';
import 'package:flutter/services.dart';

class Movie {
  final String genre;
  final String imdbRating;
  final String title;
  final String poster;
  final String year;
  final String runtime;
  final String actors;
  final String plot;
  final String awards;
  final List<String> images;
  final bool comingSoon;

  Movie({
    required this.genre,
    required this.imdbRating,
    required this.title,
    required this.poster,
    required this.year,
    required this.runtime,
    required this.actors,
    required this.plot,
    required this.awards,
    required this.images,
    this.comingSoon = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      genre: json['Genre'] as String? ?? 'Unknown',
      imdbRating: json['imdbRating'] as String? ?? '0.0',
      title: json['Title'] as String? ?? 'Unknown',
      poster: json['Poster'] as String? ?? '',
      year: json['Year'] as String? ?? 'Unknown',
      runtime: json['Runtime'] as String? ?? 'Unknown',
      actors: json['Actors'] as String? ?? 'Unknown',
      plot: json['Plot'] as String? ?? 'No plot available',
      awards: json['Awards'] as String? ?? 'No awards',
      images: (json['Images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      comingSoon: json['ComingSoon'] as bool? ?? false,
    );
  }
}

Future<List<Movie>> loadMovies() async {
  final jsonString = await rootBundle.loadString('assets/movies.json');
  final jsonData = jsonDecode(jsonString) as List<dynamic>;
  final movies = jsonData.map((movie) {
    return Movie.fromJson(movie as Map<String, dynamic>);
  }).toList();

  // Sort: regular movies by rating (descending), then Coming Soon at the end
  movies.sort((a, b) {
    // If one is Coming Soon and the other is not, Coming Soon goes last
    if (a.comingSoon && !b.comingSoon) return 1;
    if (!a.comingSoon && b.comingSoon) return -1;

    // Both are Coming Soon or both are regular - sort by rating
    double ratingA = a.imdbRating == 'N/A' ? 0 : double.parse(a.imdbRating);
    double ratingB = b.imdbRating == 'N/A' ? 0 : double.parse(b.imdbRating);
    return ratingB.compareTo(ratingA);
  });

  return movies;
}
