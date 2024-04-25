import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crud_sqflite/model/restaurant.dart';

class RestaurantsDatabase {
  static final RestaurantsDatabase instance = RestaurantsDatabase._init();

  static Database? _database;

  RestaurantsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('restaurants.db');
    return _database!;
  }

  Future<Restaurant> create(Restaurant restaurant) async {
    final db = await instance.database;
    final id = await db.insert(tableRestaurants, restaurant.toJson());

    return restaurant.copy(id: id);
  }

  Future<Restaurant> readRestaurant(int id) async {
    final db = await instance.database;

    final maps = await db.query(
        tableRestaurants,
        columns: RestaurantFields.values,
        where: '${RestaurantFields.id} = ?',
        whereArgs: [id]
    );

    if(maps.isNotEmpty){
      return Restaurant.fromJson(maps.first);
    } else {
      throw Exception('Restaurant with ID $id cannot be found');
    }
  }

  Future<List<Restaurant>> readAllRestaurants() async {
    final db = await instance.database;
    const orderBy = '${RestaurantFields.time} ASC';
    final result = await db.query(tableRestaurants, orderBy: orderBy);

    return result.map((json) => Restaurant.fromJson(json)).toList();
  }

  Future<int> update(Restaurant restaurant) async {
    final db = await instance.database;
    return db.update(
        tableRestaurants,
        restaurant.toJson(),
        where: '${RestaurantFields.id} = ?',
        whereArgs: [restaurant.id]
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
        tableRestaurants,
        where: '${RestaurantFields.id} = ?',
        whereArgs: [id]
    );
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableRestaurants (
        ${RestaurantFields.id} $idType,
         ${RestaurantFields.name} $textType,
        ${RestaurantFields.description} $textType,
        ${RestaurantFields.rating} $integerType
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
