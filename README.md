# TenTwenty - Movie Ticket Booking App

A comprehensive Flutter application for browsing movies, watching trailers, and booking tickets with a premium user experience. Built with Clean Architecture principles.

## 📱 Features

### 🎬 Watch (Movies)
- **Upcoming Movies**: Browse a list of upcoming movies fetched from TMDB API.
- **Search**: Search for movies with real-time results.
- **Movie Details**: View comprehensive movie information including genres, overview, and release dates.
- **Video Player**: Watch movie trailers in a full-screen player with auto-play functionality.

### 🎟️ Booking
- **Date & Time Selection**: Choose from available dates and showtimes.
- **Interactive Seat Map**: 
  - Zoomable and pannable seat layout.
  - Visual distinction for Available, Taken, Selected, and VIP seats.
  - Real-time price calculation based on seat selection.
  - Custom painted cinema screen curve.

### 📚 Media Library (Favorites)
- **Offline Support**: Save movies to your favorites.
- **Local Database**: Browsing favorite movies works completely offline using a local SQLite database.

### 🎨 UI/UX
- **Smooth Animations**: Hero animations, shimmer loading skeletons, and liquid pull-to-refresh.
- **Custom Design**: Rounded UI elements, glassmorphism touches, and a consistent color palette.
- **Responsive**: Adaptive layouts for both portrait and landscape orientations (especially in Tablet/Detail views).

## 🏗️ Architecture & Tech Stack

This project follows **Clean Architecture** to ensure separation of concerns, testability, and unlimited scalability.

### Layers
1.  **Presentation**: BLoC (State Management), Screens, Widgets.
2.  **Domain**: Entities, UseCases, Repository Interfaces (Pure Dart).
3.  **Data**: Repository Implementations, Data Sources (Remote/Local), Models.

### Key Packages
- **State Management**: `flutter_bloc`, `equatable`
- **Dependency Injection**: `get_it`
- **Networking**: `dio`, `retrofit`, `pretty_dio_logger`
- **Local Storage**: `sqflite` / `path` (Custom DatabaseHelper)
- **UI Utilities**: `flutter_svg`, `shimmer`, `liquid_pull_to_refresh`, `youtube_player_flutter`
- **Code Generation**: `build_runner`, `json_serializable`, `retrofit_generator`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Dart SDK

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/tentwenty.git
    cd tentwenty
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run Code Generation** (if you make changes to models/retrofit services)
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the App**
    ```bash
    flutter run
    ```

## 📂 Project Structure

```
lib/
├── core/                   # Core functionality (DI, Network, Theme, Widgets)
├── features/               # Feature-based modules
│   ├── booking/            # Booking flow (Seats, Showtimes)
│   ├── bottom_nav/         # Bottom navigation logic
│   ├── media_library/      # Favorites & Offline storage
│   ├── movie_details/      # Detail screen & interactions
│   └── watch/              # Movie listing & Search
└── main.dart               # Entry point
```

## 📸 API Reference

This app uses The Movie Database (TMDB) API.
- Base URL: `https://api.themoviedb.org/3/`
- Endpoints used: `movie/upcoming`, `search/movie`, `movie/{id}`, `movie/{id}/videos`
