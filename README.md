# Movie List - Flutter App

A Flutter application that displays movies from a JSON file with search functionality, detailed movie pages, and multi-route navigation.

## Overview

Movie List is a streaming platform prototype app that showcases a movie catalog. Users can browse top-rated movies, search by title, and view detailed information about each film including ratings, cast, plot, and awards.

## Features

- **Home Page**: Displays top-rated movies sorted by IMDB rating in descending order
- **Search Bar**: Case-insensitive partial matching (like SQL ILIKE)
- **Movie List View**: Shows movie poster, title, genre, and rating in a scrollable list
- **Movie Detail Page**: Displays comprehensive information including:
  - Movie poster
  - Title
  - IMDB rating
  - Year
  - Runtime
  - Genre
  - Main actors
  - Awards
  - Full plot description
- **Navigation**: Material Design navigation with back button support
- **Error Handling**: Graceful handling of missing images and data
- **Responsive Design**: Scrollable content to prevent overflow on all screen sizes

## Project Structure

```
movie-list/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── movie.dart            # Movie class and data loading logic
│   └── screens/
│       ├── home_page.dart        # Home page with search and movie list
│       └── movie_detail_page.dart # Movie detail page
├── assets/
│   └── movies.json               # Movie data
└── pubspec.yaml                  # Project configuration
```

## How to Run

1. Ensure you have Flutter installed on your system
2. Clone or download this project
3. Navigate to the project directory:
   ```bash
   cd movie-list
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## Key Implementation Details

### Movie Model
The `Movie` class includes:
- `genre`: Movie genre(s)
- `imdbRating`: IMDB rating score
- `title`: Movie title
- `poster`: URL to poster image
- `year`: Release year
- `runtime`: Duration in minutes
- `actors`: Main cast members
- `plot`: Movie synopsis
- `awards`: Awards and nominations

The class includes a `fromJson` factory constructor for JSON deserialization.

### Data Loading
- Uses `rootBundle.loadString()` to load the JSON file from assets
- Uses `jsonDecode()` to parse JSON data
- Sorts movies by IMDB rating in descending order
- Implements async loading with `FutureBuilder`

### Search Functionality
- Real-time search with each keystroke
- Case-insensitive matching using `toLowerCase()`
- Partial string matching (e.g., searching "vatar" finds "Avatar")
- Clear button to reset search

### Layout & Navigation
- Material Design components throughout
- Responsive layout using `Column`, `Row`, and `Expanded`
- `SingleChildScrollView` for scrollable movie detail page
- `Card` widgets for movie list items with `InkWell` for tap detection
- `Navigator.push()` for route navigation

## Technologies Used

- **Flutter**: UI framework
- **Dart**: Programming language
- **Material Design**: UI design system
- **JSON**: Data format for movies

## Testing the Search

Test the case-insensitive partial matching:
- Search "the" to find "The Shawshank Redemption", "The Godfather", etc.
- Search "lord" to find "The Lord of the Rings: The Return of the King"
- Search "ACTION" to find all action movies (case-insensitive)

## Bonus Features Implemented

- ✅ Navigation transitions with Material Route animation
- ✅ Back navigation with AppBar back button
- ✅ Error handling for missing images and data
- ✅ Responsive design preventing overflow

## Future Enhancements

Potential improvements for future versions:
- Implement local SQLite database for offline access
- Add favorite/watchlist functionality
- Add movie ratings and reviews
- Implement advanced filtering by genre, year, or rating
- Add animation on overscroll behavior
- Integrate with real movie APIs (OMDB, TMDB)

## Requirements Met

✅ Display top-rated movies sorted by rating (descending)  
✅ Tap movie to view detailed information  
✅ Search bar with case-insensitive partial matching  
✅ Movie class with required properties  
✅ fromJson method for JSON serialization  
✅ FutureBuilder for async data loading  
✅ Movie detail page with 5+ parameters  
✅ ScrollView to prevent overflow  
✅ AppBar with movie name and back button  
✅ No widget overflow on any screen  
✅ Valid Flutter project that builds and runs  
✅ Includes movies.json file  
✅ Comprehensive README documentation  

## License

This project is provided as-is for educational purposes.
