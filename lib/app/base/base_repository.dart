import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ihostel/app/app.dart';
import 'package:isar/isar.dart';

abstract class BaseRepository<T extends BaseModel<T>> {
  BaseRepository(this.isar, this.isarCollection, this.database);

  final Isar isar;
  final IsarCollection<T> isarCollection;
  final FirebaseDatabase database;
  final String tableName = '${T}s';

  List<T> get listLocal;

  T fromJson(Map<String, dynamic> json);

  int insert(T model) => isar.writeTxnSync(() => isarCollection.putSync(model));

  void save(IsarLinks<T> item) => isar.writeTxnSync(() => item.save());

  List<int> insertList(List<T> models) => isar.writeTxnSync(() => isarCollection.putAllSync(models));

  bool delete(String id) => isar.writeTxnSync(() => isarCollection.deleteSync(id.fastHash()));

  bool deleteBySyncFlag(T model) {
    if (!model.isSyncedFlag) {
      return isar.writeTxnSync(() => isarCollection.deleteSync(model.id.fastHash()));
    } else {
      insert(model.copyWith(isDeleted: true, updated: DateTime.now()));
      return false;
    }
  }

  int deleteAll() => isar.writeTxnSync(isarCollection.where().deleteAllSync);

  T? getById(String id);

  Stream<List<T>> getListStream() => isarCollection.where().watch(fireImmediately: true);

  FutureOr<List<T>> getListFirebase() async {
    return database.ref(tableName).get().then((snapshot) {
      if (snapshot.exists) {
        final list = snapshot.children
            .map((e) {
              final obj = e.value;
              if (obj == null) return null;
              final data = Map<String, dynamic>.from(obj as Map);
              return fromJson(data);
            })
            .whereNotNull()
            .toList();
        return list;
      }
      return <T>[];
    }).onError(
      (error, stackTrace) => throw Exception('Missing $tableName firebase realtime'),
    );
  }

  FutureOr<void> pushItem(T model) async {
    await database.ref(tableName).child(model.id).update(model.toJson()).whenComplete(() {
      model
        ..isSynced = true
        ..isSyncedFlag = true
        ..syncedTime = DateTime.now();
      insert(model);
    });
  }

  FutureOr<void> pull({
    VoidCallback? onCompleted,
    VoidCallback? onFailed,
  }) async {
    try {
      final listFirebase = await getListFirebase();
      final rp = ReceivePort();
      final isolate = await Isolate.spawn(IsolateEntry.pull<T>, [rp.sendPort, listLocal, listFirebase]);
      rp.listen((message) {
        final mergedList = message as List<T>;
        isar.writeTxnSync(() {
          isarCollection.putAllSync(mergedList);
        });
        onCompleted?.call();
        rp.close();
        isolate.kill(priority: Isolate.immediate);
      });
    } catch (e) {
      Log.e(e);
      onFailed?.call();
    }
  }

  FutureOr<void> push({
    VoidCallback? onCompleted,
    VoidCallback? onFailed,
  }) async {
    final rp = ReceivePort();
    final isolate = await Isolate.spawn(IsolateEntry.push<T>, [rp.sendPort, listLocal]);
    rp.listen((message) async {
      try {
        final dataLocalUpdate = message as List<T>;
        await database.ref(tableName).update(_convertListToMap(dataLocalUpdate)).then((_) {
          isar.writeTxnSync(() {
            isarCollection.putAllSync(dataLocalUpdate);
          });
        });
        onCompleted?.call();
      } catch (e) {
        Log.e(e);
        onFailed?.call();
      }
      rp.close();
      isolate.kill(priority: Isolate.immediate);
    });
  }

  FutureOr<void> sync({
    void Function(String)? onCompleted,
    void Function(String)? onFailed,
  }) async {
    try {
      Log.d(tableName);
      final listFirebase = await getListFirebase();
      final rp = ReceivePort();
      final isolate = await Isolate.spawn(IsolateEntry.sync<T>, [rp.sendPort, listLocal, listFirebase]);
      rp.listen((message) async {
        try {
          if (message is List) {
            final mergedList = message[0] as List<T>;
            final dataLocalUpdate = message[1] as List<T>;
            isar.writeTxnSync(() {
              isarCollection.putAllSync(mergedList);
            });

            await database.ref(tableName).update(_convertListToMap(dataLocalUpdate)).then((_) {
              isar.writeTxnSync(() {
                isarCollection.putAllSync(dataLocalUpdate);
              });
            });
          }
          onCompleted?.call(tableName);
        } catch (e) {
          Log.e(e);
          onFailed?.call(tableName);
        }
        rp.close();
        isolate.kill(priority: Isolate.immediate);
      });
    } catch (e) {
      Log.e(e);
      onFailed?.call(tableName);
    }
  }

  Map<String, Map<String, dynamic>> _convertListToMap(List<T> data) {
    return data.fold({}, (Map<String, Map<String, dynamic>> resultMap, model) {
      resultMap[model.id] = model.toJson();
      return resultMap;
    });
  }
}
