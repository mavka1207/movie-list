import 'package:flutter/material.dart';
import 'dart:async';
import 'package:movie_list/models/movie.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  int _currentImageIndex = 0;
  late Timer _imageTimer;

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  void _startImageRotation() {
    if (widget.movie.images.isNotEmpty) {
      _imageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        setState(() {
          _currentImageIndex =
              (_currentImageIndex + 1) % widget.movie.images.length;
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.movie.images.isNotEmpty) {
      _imageTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.movie.title), centerTitle: true, elevation: 0),
      body: Stack(
        children: [
          // Blurred background
          if (widget.movie.poster.isNotEmpty)
            Positioned.fill(
              child: Image.network(
                widget.movie.poster,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey[800]);
                },
              ),
            ),
          // Overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          // Semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster or Image Carousel
                if (widget.movie.images.isNotEmpty)
                  _buildImageCarousel()
                else
                  _buildPosterImage(),
                const SizedBox(height: 24.0),

                // Title
                Text(
                  widget.movie.title,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),

                // Rating or Coming Soon
                if (widget.movie.comingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '🎬 Coming Soon',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 180, 77),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ ${widget.movie.imdbRating} / 10',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 20.0),

                // Year
                _buildDetailRow('Year', widget.movie.year),
                const SizedBox(height: 12.0),

                // Runtime
                _buildDetailRow('Runtime', widget.movie.runtime),
                const SizedBox(height: 12.0),

                // Genre
                _buildDetailRow('Genre', widget.movie.genre),
                const SizedBox(height: 12.0),

                // Actors
                _buildDetailRow('Main Actors', widget.movie.actors),
                const SizedBox(height: 12.0),

                // Awards
                _buildDetailRow('Awards', widget.movie.awards),
                const SizedBox(height: 20.0),

                // Plot
                const Text(
                  'Plot',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(widget.movie.plot,
                    style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: widget.movie.images.isNotEmpty
                ? ClipRRect(
                    key: ValueKey<int>(_currentImageIndex),
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.movie.images[_currentImageIndex],
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12.0),

        // Page indicators
        if (widget.movie.images.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.movie.images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentImageIndex == index ? 12 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? Colors.blue
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPosterImage() {
    return Center(
      child: widget.movie.poster.isNotEmpty
          ? Hero(
              tag: widget.movie.title,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Image.network(widget.movie.poster),
              ),
            )
          : Container(
              height: 300,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image_not_supported, size: 50),
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final displayValue = value == 'N/A' ? '...' : value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
            child: Text(displayValue, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
