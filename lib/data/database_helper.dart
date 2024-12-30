import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'travel_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE travel(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_travel TEXT NOT NULL,
            rute TEXT NOT NULL,
            tanggal_keberangkatan DATE,
            waktu_keberangkatan TIME,
            harga DECIMAL(10, 2),
            kapasitas INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE penumpang(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            email TEXT UNIQUE,
            no_telepon TEXT,
            alamat TEXT,
            travel_id INTEGER,
            FOREIGN KEY (travel_id) REFERENCES travel (id)
          )
        ''');
      },
    );
  }
}
