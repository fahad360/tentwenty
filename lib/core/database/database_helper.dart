import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/watch/domain/entities/movie_entity.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movie_favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            imageUrl TEXT,
            releaseDate TEXT,
            category TEXT,
            trailerUrl TEXT
          )
          ''');
      },
    );
  }

  Future<void> insertMovie(MovieEntity movie) async {
    final db = await database;
    await db.insert('favorites', {
      'id': movie.id,
      'title': movie.title,
      'overview': movie.overview,
      'imageUrl': movie.imageUrl,
      'releaseDate': movie.releaseDate,
      'category': movie.category,
      'trailerUrl': movie.trailerUrl,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeMovie(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  Future<List<MovieEntity>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return MovieEntity(
        id: maps[i]['id'],
        title: maps[i]['title'],
        overview: maps[i]['overview'],
        imageUrl: maps[i]['imageUrl'],
        releaseDate: maps[i]['releaseDate'],
        category: maps[i]['category'] ?? '',
        genres: [],
        trailerUrl: maps[i]['trailerUrl'] ?? '',
      );
    });
  }
}
