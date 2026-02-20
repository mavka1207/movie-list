import 'package:flutter/material.dart';
import 'package:movie_list/models/movie.dart';
import 'package:movie_list/screens/movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late FocusNode _searchFocusNode;
  List<Movie> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterMovies(List<Movie> allMovies, String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMovies = allMovies;
      } else {
        _filteredMovies = allMovies
            .where(
              (movie) =>
                  movie.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Movie>>(
        future: loadMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found'));
          }

          final allMovies = snapshot.data!;

          // Initialize filtered movies on first load
          if (_filteredMovies.isEmpty) {
            _filteredMovies = allMovies;
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  autofocus: true,
                  onChanged: (query) => _filterMovies(allMovies, query),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterMovies(allMovies, '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (query) => _filterMovies(allMovies, query),
                ),
              ),

              // Movie List
              Expanded(
                child: _filteredMovies.isEmpty
                    ? const Center(child: Text('No movies match your search'))
                    : NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollStartNotification) {
                            _searchFocusNode.unfocus();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount: _filteredMovies.length,
                          itemBuilder: (context, index) {
                            final movie = _filteredMovies[index];
                            return MovieListTile(
                              movie: movie,
                              onTap: () {
                                _searchFocusNode.unfocus();
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                    pageBuilder: (_, __, ___) =>
                                        MovieDetailPage(movie: movie),
                                    transitionsBuilder:
                                        (_, animation, __, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MovieListTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieListTile({Key? key, required this.movie, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Hero(
              tag: movie.title,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Image.network(
                    movie.poster,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Movie Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (movie.comingSoon)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Coming Soon',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      )
                    else
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4.0),
                          Text(
                            movie.imdbRating,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8.0),
                    Text(
                      movie.genre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            // Chevron
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
