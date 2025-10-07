import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:ihostel/app/app.dart';

class IsolateEntry {
  static void pull<T extends BaseModel<T>>(List<Object> args) {
    final sendPort = args[0] as SendPort;
    final listLocal = args[1] as List<T>;
    final listFirebase = args[2] as List<T>;
    final mergedList = IsolateEntry()._pull<T>(listLocal, listFirebase);
    sendPort.send(mergedList);
  }

  static void push<T extends BaseModel<T>>(List<Object> args) {
    final sendPort = args[0] as SendPort;
    final listLocal = args[1] as List<T>;
    final dataLocalUpdate = IsolateEntry()._push<T>(listLocal);
    sendPort.send(dataLocalUpdate);
  }

  static void sync<T extends BaseModel<T>>(List<Object> args) {
    final sendPort = args[0] as SendPort;
    final listLocal = args[1] as List<T>;
    final listFirebase = args[2] as List<T>;
    final mergedList = IsolateEntry()._pull<T>(listLocal, listFirebase);
    final dataLocalUpdate = IsolateEntry()._push<T>(mergedList);
    sendPort.send([mergedList, dataLocalUpdate]);
  }

  List<T> _pull<T extends BaseModel<T>>(List<T> listLocal, List<T> listFirebase) {
    final mergedList = listFirebase;
    for (final local in listLocal) {
      final iRemoteOrNull = listFirebase.firstWhereOrNull((firebase) => firebase.id == local.id);
      if (iRemoteOrNull == null) {
        mergedList.add(local..isSynced = false);
      } else {
        mergedList.remove(iRemoteOrNull);
        final iLocal = local..isSynced = false;
        final iRemote = iRemoteOrNull..isSynced = true;
        final newItem = iRemoteOrNull.getUpdated.isBefore(local.getUpdated.toUtc()) ? iLocal : iRemote;
        mergedList.add(newItem);
      }
    }
    return mergedList;
  }

  List<T> _push<T extends BaseModel<T>>(List<T> listLocal) {
    final dataLocalUpdate = listLocal
        .where((element) => !element.isSynced)
        .map(
          (e) => e.convertUtc()
            ..isSyncedFlag = true
            ..isSynced = true
            ..updated = e.getUpdated.toUtc()
            ..created = e.getCreated.toUtc()
            ..syncedTime = DateTime.now().toUtc(),
        )
        .toList();
    return dataLocalUpdate;
  }
}
