import 'dart:async';
import 'dart:io';

import 'package:buttons/models/board_configuration.dart';
import 'package:buttons/models/difficulty.dart';
import 'package:buttons/util/pseudo_random.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as pather;
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  final PseudoRandom rand = new PseudoRandom();
  Database _db;

  var _fieldsCountMap = <String, int>{};

  Future<void> initService() async {

    await _doCopyDatabase();

    _db = await openReadOnlyDatabase(await _getDBPath());
    for (var size in BoardConfiguration.boardSizes) {
      for (var diff in Difficulty.stringValues) {
        final dbName = 'data_${size}_$diff';
        final count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM $dbName"));
        _fieldsCountMap[dbName] = count;
      }
    }
    print('DB initialized');
  }

  Future<int> getNewSeedForGame(int boardSize, Difficulty difficulty) async {
    _db = await openDatabase(await _getDBPath(), version: 1);
    final dbName = 'data_${boardSize}_${difficulty.stringValue}';
    final maxCount =_fieldsCountMap[dbName];
    final offset = rand.nextInt(maxCount);
    final seed = (await _db.query(dbName, limit: 1, offset: offset)).first['seed'];
    return seed;
  }

  Future<void> _doCopyDatabase() async {

    // Copy from asset
    ByteData data = await rootBundle.load(pather.join("assets", "db", "fields.db"));
    print("loaded!");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    print("readed!");
    final path = await _getDBPath();
    final folder = Directory(pather.dirname(path));
    if (!await folder.exists()) {
      await folder.create();
    }
    await File(path).writeAsBytes(bytes);
    print("copied!");
  }

  Future<String> _getDBPath() async {
    var databasesPath = await getDatabasesPath();
    return pather.join(databasesPath, "fields.db");
  }
}