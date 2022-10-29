import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/* expose repositories for rest of application to use */
final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return DatabaseRepository();
});

/* 
  This is an interface for the database repository.
  Mock repository makes it easy to test the controller. 
  */
abstract class IDatabaseRepository {
  FutureOr<void> copyDatabaseFromFile();
}

class MockDatabaseRepository implements IDatabaseRepository {
  @override
  Future<void> copyDatabaseFromFile() async {
    await Future.delayed(Duration(milliseconds: 5));
    return;
  }
}

class DatabaseRepository implements IDatabaseRepository {
  @override
  Future<void> copyDatabaseFromFile() async {
    // Search and create db file destination folder if not exist
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final objectBoxDirectory = Directory('${documentsDirectory.path}/objectbox/');

    if (!objectBoxDirectory.existsSync()) {
      await objectBoxDirectory.create(recursive: true);
    }

    final dbFile = File('${objectBoxDirectory.path}/data.mdb');
    final dbLockFile = File('${objectBoxDirectory.path}/lock.mdb');
    // dbFile.delete();
    // dbLockFile.delete();

    if (!dbFile.existsSync()) {
      // Get pre-populated db file and db lock file.
      ByteData dbData = await rootBundle.load("assets/databases/data.mdb");
      // ByteData lockData = await rootBundle.load("assets/databases/lock.mdb");

      // Copying source data into destination file.
      await dbFile.writeAsBytes(dbData.buffer.asUint8List());
      // await dbLockFile.writeAsBytes(lockData.buffer.asUint8List());
      print("=== saved database from assets to application.");
    } else {
      print("=== application is running with loaded database.");
    }
    return;
  }
}
