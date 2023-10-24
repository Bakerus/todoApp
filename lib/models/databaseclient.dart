import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'item.dart';

class DatabaseClient {
  static Database? database;
  var db;
  int id=0;
  static List<Map<String, dynamic>> mapsLists=[];
  String path = join(getDatabasesPath().toString(), 'database.db');


  // Cette fonction permet de verifier si une base de donnée est déjà créé
  Future<Database?> createDB() async {
    if (await databaseExists(path)) {
      database = await openDatabase(path);
      db = database;
      return database;
    } else {
      database = await create();
      db = database;
      return database;
    }
  }

  //Cette fonction permet de créer une base de donnée si elle n'hesite pas encore
  Future<Database> create() async {
    var bdd = await openDatabase(path, version: 1,
        onCreate: ((Database db, int version) async {
      await db.execute('''
                 CREATE TABLE item (
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 name Text NOT NULL)
                 ''');
    }));
    return bdd;
  }

  //Cette fonction permet d'inserer des elements dans la table item de la base de donnée existante
  Future<void> insertItem(Item item) async{
   item.id = await db.insert(
      'item',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//Cette fonction permet de recuperer les elements de la table item dans une base de donnée existante
  Future<List<Item>> getItem() async {
    mapsLists = await db.query('item');
    // print(mapsLists);
    return List.generate(mapsLists.length, (index) {
      return Item(id: mapsLists[index]['id'], name: mapsLists[index]['name']);
    });
  }

//Cette fonction permet de supprimer les elements de la table item dans une base de donnée existante
  Future<void> deleteItem(int id) async{
    await db.delete(
      'item',
      where: 'id= ?',
      whereArgs: [id],
    );
  }

//Cette fonction permet de modifier la valeur des elements de la table item dans une base de donnée existante
Future<void> updateItem(Item item) async{
    await db.update(
      'item',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id]
    );
}


}