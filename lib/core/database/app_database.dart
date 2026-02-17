import 'package:path/path.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static AppDatabase? appDatabase;
  AppDatabase._();

  factory AppDatabase() {
    appDatabase ??= AppDatabase._();
    return appDatabase!;
  }

  Future<Database> get database async {
    var path = await getDatabasesPath();
    var db = await openDatabase(
      join(path, 'pixhunt.db'),
      onCreate: (db, version) async {
        await db.execute(Pexer.createTable);
        await db.execute(Photos.createTable);
      },
      version: 1,
    );
    return db;
  }
}
