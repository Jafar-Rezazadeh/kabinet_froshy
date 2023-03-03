import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//? kabinet models class
class KabinetModels {
  final int? id;
  final String name;
  final String price;
  final String stock;
  final Uint8List picture;

  const KabinetModels({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.picture,
  });

  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'picture': picture,
    };
  }
}

//Todo: adding the date column to the TbSold table and the class of it
//? sold models table class
class kSold {
  final int? id;
  final String name;
  final String price;
  final String stock;
  final DateTime date;

  const kSold({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.date,
  });

  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'date': date,
    };
  }
}

String _TbKmodeN = "Kmodels";
String _TbSold = "kSold";

class database_K {
  //opening the db
  openDb() async {
    //!: the path changes after picking a file but it is effect in debug mode after hot restart the the app not in relase mode
    String p = join(await databaseFactoryFfi.getDatabasesPath(), 'Database.db');
    if (kDebugMode) {
      print(p);
    }

    final db = await databaseFactoryFfi.openDatabase(p,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
                  CREATE TABLE $_TbKmodeN (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  name TEXT ,
                  price TEXT ,
                  stock TEXT ,
                  picture BLOB )''');
            await db.execute('''
                  CREATE TABLE $_TbSold (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  name TEXT ,
                  price TEXT ,
                  stock TEXT ,
                  date INTEGER )''');
          },
        ));

    return db;
  }

//***  kmodel table functionalities -------------------------- */
  //insert KabinetModels in it
  insertKabinetModels(KabinetModels kabinetModels) async {
    final db = await openDb();
    int a = await db.insert(
      _TbKmodeN,
      <String, Object?>{
        'name': kabinetModels.name,
        'price': kabinetModels.price,
        'stock': kabinetModels.stock,
        'picture': kabinetModels.picture,
      },
    );
    return a;
  }

  //delete function
  deleteKM(int id) async {
    final db = await openDb();
    db.delete(
      _TbKmodeN,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //update function
  updateKbDb(KabinetModels kabinetModels) async {
    final db = await openDb();
    db.update(
      _TbKmodeN,
      <String, Object?>{
        'id': kabinetModels.id,
        'name': kabinetModels.name,
        'price': kabinetModels.price,
        'stock': kabinetModels.stock,
        'picture': kabinetModels.picture,
      },
      where: 'id = ?',
      whereArgs: [kabinetModels.id],
    );
  }

  //get all Kmodels as list<KabinetModels>
  Future<List<KabinetModels>> getKmodels() async {
    final db = await openDb();

    //*geting the data as map
    var maps = await db.query(_TbKmodeN, orderBy: 'id DESC');

    //*and converting it to the list of kabinetModels

    return List.generate(maps.length, (i) {
      return KabinetModels(
        id: int.parse(maps[i]['id'].toString()),
        name: maps[i]['name'],
        price: maps[i]['price'],
        stock: maps[i]['stock'],
        picture: maps[i]['picture'],
      );
    });
  }
  //***  kmodel table functionalities *end* -------------------------- */

//
//
  //***  TbSold table functionalities -------------------------------- */
//insert TbSold
  insertTbSold(kSold ksold) async {
    final db = await openDb();
    int a = await db.insert(
      _TbSold,
      <String, Object?>{
        'name': ksold.name,
        'price': ksold.price,
        'stock': ksold.stock,
        'date': ksold.date.toLocal().millisecondsSinceEpoch
        //Todo:
      },
    );
    return a;
  }

//delete function
  deleteTbSold() async {
    final db = await openDb();
    db.execute('DELETE FROM $_TbSold ');
  }

//update function
  updateTbSold(kSold ksold) async {
    final db = await openDb();
    db.update(
      _TbSold,
      <String, Object?>{
        'id': ksold.id,
        'name': ksold.name,
        'price': ksold.price,
        'stock': ksold.stock,
      },
      where: 'id = ?',
      whereArgs: [ksold.id],
    );
  }

  //get all Kmodels as list<KabinetModels>
  Future<List<kSold>> getTbSold() async {
    final db = await openDb();

    //*geting the data as map
    var maps = await db.query(_TbSold, orderBy: 'id DESC');

    //*and converting it to the list of kabinetModels
    return List.generate(maps.length, (i) {
      return kSold(
        id: int.parse(maps[i]['id'].toString()),
        name: maps[i]['name'],
        price: maps[i]['price'],
        stock: maps[i]['stock'],
        date: DateTime.fromMillisecondsSinceEpoch(maps[i]['date']),
      );
    });
  }

  //***  TbSold table functionalities *end* -------------------------- */
}
