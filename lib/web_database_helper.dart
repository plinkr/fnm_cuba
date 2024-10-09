import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:archive/archive_io.dart';

class WebDatabaseHelper {
  static final WebDatabaseHelper _instance = WebDatabaseHelper._internal();
  Database? _database; // Base de datos cacheada

  factory WebDatabaseHelper() {
    return _instance;
  }

  WebDatabaseHelper._internal();

  // Getter optimizado para la base de datos, con inicialización diferida
  Future<Database> get database async {
    // Solo inicializamos si no está ya inicializada
    if (_database != null) return _database!;

    _database = await _initDatabase(); // Inicialización diferida
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Esto sería para usarlo en otras plataformas, por ahora no tiene uso
    String dbPath = 'assets/fnm.db';

    if (kIsWeb) {
      var databaseFactory = databaseFactoryFfiWeb;

      // Cargamos la BD comprimida con XZ desde assets
      final compressedData =
          await rootBundle.load(url.join('assets', 'fnm.db.xz'));
      final compressedBytes = compressedData.buffer.asUint8List(
          compressedData.offsetInBytes, compressedData.lengthInBytes);

      // Descomprimimos los bytes
      final decompressedBytes = await decompressBytes(compressedBytes);

      // Escribimos los bytes en la base de datos web
      await databaseFactory.writeDatabaseBytes(
          'formulario_web.db', decompressedBytes);

      // Abrimos la base de datos en modo solo lectura
      return await databaseFactory.openDatabase('formulario_web.db',
          options: OpenDatabaseOptions(readOnly: true));
    } else {
      // Abrimos la base de datos local en modo solo lectura
      return await openDatabase(dbPath, readOnly: true);
    }
  }

  // Cierre de la base de datos
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Método para descomprimir el archivo usando archive_io
  Future<Uint8List> decompressBytes(Uint8List compressedBytes) async {
    // Descomprimimos los bytes usando la biblioteca 'archive' con XZDecoder
    final archive = XZDecoder().decodeBytes(compressedBytes);
    return Uint8List.fromList(archive);
  }

  Future<List<Map<String, dynamic>>> searchMedicineByProductoOrCategoria(
      String query, int offset, int limit) async {
    final db = await database;
    final normalizedQuery = removeAccents(query).toLowerCase();

    return await db.rawQuery('''
    SELECT * FROM Datos
    WHERE LOWER(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(Producto, 'Á', 'A'),
              'É', 'E'),
            'Í', 'I'),
          'Ó', 'O'),
        'Ú', 'U')
      ) LIKE ?
    OR LOWER(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(CategFarm, 'Á', 'A'),
              'É', 'E'),
            'Í', 'I'),
          'Ó', 'O'),
        'Ú', 'U')
      ) LIKE ?
    LIMIT ? OFFSET ?
  ''', ['%$normalizedQuery%', '%$normalizedQuery%', limit, offset]);
  }

  // Método para obtener todos los registros de la tabla Datos,
  // este metodo no ordena bien las tildes, Á la coloca despues de la Z
  // Future<List<Map<String, dynamic>>> getAllFromDataAlphaSorted(
  //     {int offset = 0, int limit = 20}) async {
  //   final db = await database;
  //   return await db.query('Datos',
  //       columns: ['_id', 'Producto', 'Presentacion', 'Presentacion1'],
  //       orderBy: 'Producto',
  //       limit: limit,
  //       offset: offset);
  // }

  // Método para obtener todos los registros de la tabla Datos
  Future<List<Map<String, dynamic>>> getAllFromDataAlphaSorted(
      {int offset = 0, int limit = 20, String sortOrder = 'ASC'}) async {
    final db = await database;
    final String query = '''
    SELECT _id, Producto, Presentacion, Presentacion1
    FROM Datos
    ORDER BY 
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(Producto, 'Á', 'A'),
              'É', 'E'),
            'Í', 'I'),
          'Ó', 'O'),
        'Ú', 'U') COLLATE NOCASE $sortOrder
    LIMIT ? OFFSET ?
  ''';

    return await db.rawQuery(query, [limit, offset]);
  }

  // Método para obtener un registro por ID en la tabla Datos
  Future<Map<String, dynamic>?> getByIdFromDatos(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'Datos',
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

// Método para obtener todos los registros de la tabla CategFarm
  Future<List<Map<String, dynamic>>> getAllFromCategFarmAlphaSorted(
      {String sortOrder = 'ASC'}) async {
    final db = await database;
    return await db.query('CategFarm',
        columns: ['CategFarm'], orderBy: 'CategFarm $sortOrder');
  }

  // Método para obtener todos los registros de la tabla Datos por una
  // categoría farmacológica determinada
  Future<List<Map<String, dynamic>>> getAllFromDataByCategFarmAlphaSorted(
      String categFarm,
      {String sortOrder = 'ASC'}) async {
    final db = await database;
    final String query = '''
    SELECT _id, Producto, Presentacion, Presentacion1
    FROM Datos
    WHERE LOWER(CategFarm) LIKE LOWER(?)
    ORDER BY 
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(Producto, 'Á', 'A'),
              'É', 'E'),
            'Í', 'I'),
          'Ó', 'O'),
        'Ú', 'U') COLLATE NOCASE $sortOrder
  ''';

    return await db.rawQuery(query, ['%$categFarm%']);
  }

  // Método para obtener todas las presentaciones de la tabla Datos
  Future<List<Map<String, dynamic>>> getPresentacionesFromDatosAlphaSorted(
      {String sortOrder = 'ASC'}) async {
    final db = await database;
    final String query = '''
    SELECT DISTINCT Presentacion
    FROM Datos
    ORDER BY Presentacion $sortOrder
  ''';

    return await db.rawQuery(query);
  }

  // Método para obtener todos los registros de la tabla Datos por una
  // presentación médica determinada
  Future<List<Map<String, dynamic>>> getAllFromDataByPresentacionAlphaSorted(
      String presentacion,
      {String sortOrder = 'ASC'}) async {
    final db = await database;
    final String query = '''
    SELECT _id, Producto, Presentacion, Presentacion1
    FROM Datos
    WHERE LOWER(Presentacion) = LOWER(?)
    ORDER BY 
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(Producto, 'Á', 'A'),
              'É', 'E'),
            'Í', 'I'),
          'Ó', 'O'),
        'Ú', 'U') COLLATE NOCASE $sortOrder
  ''';

    return await db.rawQuery(query, [presentacion]);
  }

// Método para obtener todos los registros de la tabla Datos donde
// existen riesgos de ese medicamento por tipoRiesgo
  Future<List<Map<String, dynamic>>>
      getAllFromDataByRiesgosOPrecaucionesAlphaSorted(String tipoRiesgo,
          {String sortOrder = 'ASC'}) async {
    final db = await database;
    String query;
    List<dynamic> args;

    if (tipoRiesgo == 'LM:') {
      // Caso especial para 'LM:', en caso que sea 'LM: Compatible' no lo muestro
      query = '''
    SELECT _id, Producto, Presentacion, Presentacion1
    FROM Datos
    WHERE (PoblacEspec LIKE ? OR Precauciones LIKE ?)
    AND (PoblacEspec NOT LIKE ? AND Precauciones NOT LIKE ?)
    ORDER BY 
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(Producto, 'Á', 'A'),
              'É', 'E'),
            'Í', 'I'),
          'Ó', 'O'),
        'Ú', 'U') COLLATE NOCASE $sortOrder
  ''';
      args = [
        '%$tipoRiesgo%',
        '%$tipoRiesgo%',
        '%LM: Compatible%',
        '%LM: Compatible%'
      ];
    } else {
      query = '''
    SELECT _id, Producto, Presentacion, Presentacion1
    FROM Datos
    WHERE PoblacEspec LIKE ? OR Precauciones LIKE ?
    ORDER BY 
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(Producto, 'Á', 'A'),
              'É', 'E'),
            'Í', 'I'),
          'Ó', 'O'),
        'Ú', 'U') COLLATE NOCASE $sortOrder
  ''';
      args = ['%$tipoRiesgo%', '%$tipoRiesgo%'];
    }

    return await db.rawQuery(query, args);
  }

  // Método genérico para realizar consultas SELECT
  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  // Método para obtener todos los registros de una tabla
  Future<List<Map<String, dynamic>>> getAllFromTable(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // Método para obtener un registro por ID
  Future<Map<String, dynamic>?> getById(String tableName, int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  String removeAccents(String text) {
    final Map<String, String> accentsMap = {
      'Á': 'A',
      'É': 'E',
      'Í': 'I',
      'Ó': 'O',
      'Ú': 'U',
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
    };

    return text.splitMapJoin(
      RegExp(r'[ÁÉÍÓÚáéíóú]'),
      onMatch: (m) => accentsMap[m.group(0)!]!,
      onNonMatch: (n) => n,
    );
  }
}
