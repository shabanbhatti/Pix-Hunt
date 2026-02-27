import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/core/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  final AppDatabase appDatabase;

  const LocalDatabaseService({required this.appDatabase});

  Future<List<Photos>> getPhotos(String title, int page) async {
    print('(PHOTOS)=SEARCH: ${title}, PAGE: ${page}');
    var db = await appDatabase.database;
    var data = await db.query(
      Photos.tableName,
      where: '${Photos.titleCol} = ? AND ${Photos.pageCol} = ?',
      whereArgs: [title, page],
    );
    return data.map((e) => Photos.fromDb(e)).toList();
  }

  Future<bool> hasPexer(String title, int page) async {
    var db = await appDatabase.database;
    var data = await db.query(
      Pexer.tableName,
      columns: ['COUNT(*) as count'],
      where: '${Pexer.titleCol} = ? AND ${Pexer.pageCol} = ?',
      whereArgs: [title, page],
    );

    final count = Sqflite.firstIntValue(data) ?? 0;
    return count > 0;
  }

  Future<Pexer> getPhotosByTitle(String title, int page) async {
    print('(PHOTOS BY TITLE)=SEARCH: ${title}, PAGE: ${page}');
    var db = await appDatabase.database;
    var data = await db.query(
      Pexer.tableName,
      where: '${Pexer.titleCol} = ? AND ${Pexer.pageCol} = ?',
      whereArgs: [title, page],
    );
    return Pexer.fromDb(data[0]);
  }

  Future<bool> insertPhotos(Photos photos) async {
    var db = await appDatabase.database;
    var data = await db.insert(
      Photos.tableName,
      photos.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return data > 0;
  }

  Future<bool> insertPhotosTitle(Pexer pexer) async {
    var db = await appDatabase.database;
    var data = await db.insert(
      Pexer.tableName,
      pexer.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return data > 0;
  }

  Future<bool> updatePhotos(Photos photos) async {
    var db = await appDatabase.database;
    var data = await db.update(
      Photos.tableName,
      photos.toDb(),
      where: '${Photos.idCol}=?',
      whereArgs: [photos.id],
    );
    return data > 0;
  }

  Future<void> deleteAllData() async {
    final db = await appDatabase.database;

    await db.delete(Pexer.tableName);
    await db.delete(Photos.tableName);
  }
}
