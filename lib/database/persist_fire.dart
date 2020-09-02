import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'products';
  static final tableCategories = 'categories';
  static final tableFeatured = 'Featured';

  static final colDocId = 'product_id';
  static final colAvail = 'available';
  static final colCat = 'category';
  static final colDiscount = 'discount';
  static final colImgUrl ='img_url';
  static final colName = 'name';
  static final colQty = 'qty';
  static final colUnits = 'units';
  static final colPrice = 'price';
  static final colOldPrice = 'old_price';
  static final colDetails = 'detail';
  static final colFeatured = 'featured';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnAge = 'age';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $table (
            $colDocId TEXT PRIMARY KEY,
            $colAvail NUMERIC NOT NULL,
            $colCat TEXT NOT NULL,
            $colDiscount NUMERIC NOT NULL,
            $colImgUrl TEXT NOT NULL,
            $colName TEXT NOT NULL,
            $colOldPrice NUMERIC,
            $colPrice NUMERIC NOT NULL,
            $colQty NUMERIC NOT NULL,
            $colUnits TEXT NOT NULL,
            $colDetails TEXT NOT NULL,
            $colFeatured NUMERIC NOT NULL
          );
          
          '''
    );
    await db.execute('''CREATE TABLE $tableCategories(
          $colCat TEXT PRIMARY KEY
          );''');
    await db.execute('''
          CREATE TABLE $tableFeatured(
          $colDocId TEXT PRIMARY KEY
          );''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> insertFeatured(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableFeatured, row);
  }
  Future<int> insertCategories(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableCategories, row);
  }

  //The data present in the table is returned as a List of Map, where each
  // row is of type map
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
  Future<List<Map<String, dynamic>>> queryFeaturedRows() async {
    print("@@@Featured");
    Database db = await instance.database;
    return await db.rawQuery('''
        SELECT $table.$colDocId,
            $colAvail,
            $colCat,
            $colDiscount,
            $colImgUrl,
            $colName,
            $colOldPrice,
            $colPrice,
            $colQty,
            $colUnits,
            $colDetails,
            $colFeatured
        FROM $table
        INNER JOIN $tableFeatured 
        ON  $table.$colDocId = $tableFeatured .$colDocId;
        ''');
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
//  Future<int> queryRowCount() async {
//    Database db = await instance.database;
//    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
//  }
//
//  // We are assuming here that the id column in the map is set. The other
//  // column values will be used to update the row.
//  Future<int> update(Map<String, dynamic> row) async {
//    Database db = await instance.database;
//    int id = row[columnId];
//    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
//  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<List<Map<String, dynamic>>> emptyTable() async {
    Database db = await instance.database;
    return await db.rawQuery('''DELETE FROM $table;
    VACUUM;
    DELETE FROM $tableCategories;
    VACUUM;''');
  }

  Future<List<Map<String, dynamic>>> emptyFeaturedTable() async {
    Database db = await instance.database;
    return await db.rawQuery('''DELETE FROM $tableFeatured;VACUUM;''');
  }
  Future<List<Map<String, dynamic>>> emptyCategoriesTable() async {
    Database db = await instance.database;
    return await db.rawQuery('''DELETE FROM $tableCategories;VACUUM;''');
  }


  Future<List<Map<String, dynamic>>> queryFeaturedTableRows() async {
    Database db = await instance.database;
    return await db.query(tableFeatured);
  }
  Future<List<Map<String, dynamic>>> queryCategoryTableRows() async {
    Database db = await instance.database;
    return await db.query(tableCategories);
  }

  void _query() async {
    final allRows = await queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }


  Future<Map<int,QueryDocumentSnapshot>> fetchFromFire() async {
    Map<int, QueryDocumentSnapshot> products;
    try{
      await FirebaseFirestore.instance
          .collection('products')
          .get()
          .then((QuerySnapshot querySnapshot) => {
        products = querySnapshot.docs.asMap()
//          querySnapshot.docs.forEach((doc) {
//        print(doc.data());
//        products = doc.documentID;
//      })
      });
      return products;
    }
    catch(e){
      print("@@"+e.toString());
      return null;
    }
  }
  Set<String> categories = new  Set();
  List<String> featured = new List();

  Future<bool> refresh() async {
    Database db = await instance.database;
    print("@@"+db.path.toString());

    //Delete table entries
    List<Map<String, dynamic>> delete = await emptyTable();

    print("@@#"+delete.toString());
    delete = await emptyFeaturedTable();
    print("@@#"+delete.toString());
    delete = await emptyCategoriesTable();
    print("@@#"+delete.toString());

    Map<int,QueryDocumentSnapshot> products = await fetchFromFire();
    if (products.isNotEmpty){
      categories.clear();
      featured.clear();
      products.forEach((key, val) async {
        print("@@val :"+val.id);
        print("@@val :"+val.data().toString());

        //Map<String, dynamic> productVal= val.data();
        print("@@valtype"+ val.data().runtimeType.toString());

        categories.add(val.data()[colCat].toString());
        if(val.data()[colFeatured]){
          featured.add(val.id.toString());
          print("@@!!"+val.data()[colFeatured].toString());
          print("@@!!"+val.id.toString());
        }
        Map<String, dynamic> row = {
          DatabaseHelper.colDocId : val.id,
          DatabaseHelper.colAvail  : val.data()[colAvail],
          DatabaseHelper.colCat  : val.data()[colCat],
          DatabaseHelper.colDiscount  : val.data()[colDiscount],
          DatabaseHelper.colImgUrl  : val.data()[colImgUrl],
          DatabaseHelper.colOldPrice  : val.data()[colOldPrice],
          DatabaseHelper.colPrice  : val.data()[colPrice],
          DatabaseHelper.colQty  : val.data()[colQty],
          DatabaseHelper.colUnits  : val.data()[colUnits],
          DatabaseHelper.colName  : val.data()[colName],
          DatabaseHelper.colDetails  : val.data()[colDetails],
          DatabaseHelper.colFeatured  : val.data()[colFeatured],
        };

        final id = await insert(row);
        print('inserted row id: $id');
      });
      //categories refresh
      categories.forEach((element) async {
        Map<String, dynamic> row = {
          DatabaseHelper.colCat : element,
        };

        final id = await insertCategories(row);
        print('Categories inserted row id: $id');
      });
      //featured refresh

      print("@@Featured  : "+ featured.toString());
      List<Map<String, dynamic>> f = await queryFeaturedTableRows();
      print("@@!Featured  : "+ f.toString());
      featured.forEach((element) async {
        Map<String, dynamic> row = {
          DatabaseHelper.colDocId : element,
        };

        final id = await insertFeatured(row);

        print('Featured inserted row id: $id');
      });
      print("@@!"+categories.toString());
      print("@@!"+featured.toString());
      //
    }else{
      print("@@Empty");
    }
    _query();
    return true;
  }
}