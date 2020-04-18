import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zencartos/sqlite/Payement.dart';
import 'package:zencartos/sqlite/contribuable.dart';


class DBHelper{
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String SIGLE = 'sigle';
  static const String NIU = 'niu';
  static const String LONG = 'long';
  static const String LAT= 'lat';
  static const String datePaye = 'datePaye';
  static const String autorisation = 'autorisation';

  static const String ACTIVITE = 'activite';
  static const String TABLE = 'Contribuable';
  static const String DB_NAME = 'ZenCartosDB.db';

  //creation de la table payement
  static const String tablepayement = 'tablepayement';
static const String idpayement = 'id';
 static const String niupayement = 'niu';
  static const String montantpayement = 'montant';
   static const String datePayepayement = 'datePaye';
     static const String idandroidpayement = 'idandroid';


  Future<Database> get db async{
    if(_db != null){
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  // from NANA
  

  // use the initDb function to retrieve the directory where my DB is created
  initDb() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{

    await db.execute("CREATE TABLE $TABLE ($ID INTEGER , $NAME TEXT, $SIGLE TEXT, $NIU VARCHAR(100) PRIMARY KEY, $ACTIVITE TEXT  ,$LONG DOUBLE ,$LAT DOUBLE,$datePaye DATETIME,$autorisation VARCHAR(100))");
  await db.execute("CREATE TABLE $tablepayement ($idpayement INTEGER PRIMARY KEY AUTOINCREMENT , $niupayement VARCHAR(100), $idandroidpayement VARCHAR(100), $montantpayement VARCHAR(100), $datePayepayement DATETIME)");

  }

  Future<Contribuable> save(Contribuable contribuable) async{
    var dbClient = await db;
    contribuable.id = await dbClient.insert(TABLE, contribuable.toMap());
    return contribuable;


    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('"+employee.name+ "')";
      return await txn.rawInsert(query);
    });
    */

  }

  Future<List<Contribuable>> getContribuables() async{
       Database db=await this.db;
    

   var result=await db.rawQuery('SELECT * FROM $TABLE');
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Contribuable> contribuables = [];
    if(result.length > 0){
      for (int i = 0; i < result.length; i++){
        contribuables.add(Contribuable.fromMap(result[i]));
      }
    }
    return contribuables;
  }
  //ici je recupere les contribuables mapper

  Future<List<Map<String,dynamic>>> getcontribuables2()async{
    Database db=await this.db;
    var result=await db.rawQuery('SELECT * FROM $TABLE');//ici je selectionne tout dans la bd
    return result;

  }

    Future<List<Map<String,dynamic>>> getcontribuablesPrecis(Contribuable contribuable)async{
    Database db=await this.db;
    var result=await db.rawQuery("SELECT * FROM $TABLE WHERE $NIU='${contribuable.niu}'");//ici je selectionne tout dans la bd
    return result;

  }

  Future<int> delete(String nui) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$NIU = ?', whereArgs: [nui]);
  }

  Future<int> update(Contribuable contribuable) async{
    var dbClient = await db;
    return await dbClient.update(TABLE, contribuable.toMap(), where: '$NIU = ?', whereArgs: [contribuable.niu]);
  }


  //gestion du versemment
  Future<int>insertPayement(Payement payement)async{
  Database db=await this.db;
  
  var result=await db.insert(tablepayement, payement.mapperpayement());
  print("payement bien inserer ");
  return result;

}
    Future<List<Map<String,dynamic>>> getpayementPrecis(Payement payement)async{
    Database db=await this.db;
    var result=await db.rawQuery("SELECT * FROM $tablepayement WHERE $niupayement='${payement.niu}' AND $datePayepayement='${payement.datePaye}' AND $idandroidpayement='${payement.idandroid}'");//ici je selectionne tout dans la bd
    return result;


  }



     Future<List<Map<String,dynamic>>> getpayement(Contribuable contribuable)async{
    Database db=await this.db;
    var result=await db.rawQuery("SELECT * FROM $tablepayement WHERE $niupayement='${contribuable.niu}'");//ici je selectionne tout dans la bd
    return result;


  }
  Future close() async{
    var dbClient = await db;
    dbClient.close();
  }
}