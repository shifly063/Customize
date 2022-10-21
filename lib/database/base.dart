import 'package:customize/inputVar/datainput.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Base {
  static final Base _instance = Base._internal();
  static Database? _database;

  //inisialisasi beberapa variabel yang dibutuhkan
  final String Mytable = 'tablelist';
  final String Idcol = 'id';
  final String judulcol = 'judul';
  final String datecol = 'date';
  final String custcol = 'cust';
  final String partcol = 'partner';
  final String descol = 'descrip';

  Base._internal();
  factory Base() => _instance;

  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'list.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //selanjutnya akan dibuat tabel
  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $Mytable($Idcol INTEGER PRIMARY KEY, "
        "$judulcol TEXT,"
        "$datecol TEXT,"
        "$custcol TEXT,"
        "$partcol TEXT,"
        "$descol TEXT)";
    await db.execute(sql);
  }

  //memasukan ke database
  Future<int?> savelist(Data inputdata) async {
    var dbClient = await _db;
    return await dbClient!.insert(Mytable, inputdata.toMap());
  }

  //menampilkan data dari database
  Future<List?> putData() async {
    var dbClient = await _db;
    var result = await dbClient!.query(Mytable,
        columns: [Idcol, judulcol, partcol, datecol, custcol, descol]);

    return result.toList();
  }

  //edit data yan teralh terinput dari database
  Future<int?> updatelist(Data inputdata) async {
    var dbClient = await _db;
    return await dbClient!.update(Mytable, inputdata.toMap(),
        where: '$Idcol = ?', whereArgs: [inputdata.id]);
  }

  //hapus database
  Future<int?> deletelist(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(Mytable, where: '$Idcol = ?', whereArgs: [id]);
  }
}
