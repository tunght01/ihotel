import 'dart:async';

import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/repository/ez_group/ez_group_repository.dart';
import 'package:ihostel/app/data/repository/ez_group_room/ez_group_room_repository.dart';
import 'package:ihostel/app/data/repository/ez_group_room_user/ez_group_room_user_repository.dart';
import 'package:ihostel/app/data/repository/ez_user/ez_user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class SyncUseCase {
  SyncUseCase(
    this.ezUserRepository,
    this.ezGroupRepository,
    this.ezGroupRoomRepository,
    this.ezGroupRoomUserRepository,
  ) {
    _syncSubscription = _sync$.stream.debounceTime(_debounceTime).listen((_) => _syncDebounced());
    _countSyncSubscription = _countSyncStream.stream.listen(_onSyncCountChanged);
    _listRepo.addAll([
      ezUserRepository,
      ezGroupRepository,
      ezGroupRoomRepository,
      ezGroupRoomUserRepository,
    ]);
    _totalSyncTasks = _listRepo.length;
  }

  final EzUserRepository ezUserRepository;
  final EzGroupRepository ezGroupRepository;
  final EzGroupRoomRepository ezGroupRoomRepository;
  final EzGroupRoomUserRepository ezGroupRoomUserRepository;

  final StreamController<void> _sync$ = StreamController<void>();
  late StreamSubscription<void> _syncSubscription;
  final StreamController<int> _countSyncStream = StreamController<int>();
  late StreamSubscription<int> _countSyncSubscription;

  final BehaviorSubject<bool> _isSyncRunning = BehaviorSubject();

  Stream<bool> get isSyncRunning => _isSyncRunning.stream.asBroadcastStream();

  static const _debounceTime = Duration(milliseconds: 2000);
  Timer? _timer;
  bool _firstSync = true;
  bool _doingSync = false;
  int _completedSyncCount = 0;
  final _listRepo = <BaseRepository>[];
  int _totalSyncTasks = 0;

  FutureOr<void> syncAll() {
    final isActive = !(_timer?.isActive ?? false);
    if (_firstSync && isActive) {
      Log.d('first $_firstSync');
      _syncImmediate();
    }
    countdown();
    _sync$.add(null);
  }

  void _syncImmediate() {
    if (!_doingSync) {
      _doSync();
    }
  }

  void _syncDebounced() {
    if (!_doingSync) {
      _doSync();
    }
  }

  void _doSync() {
    _doingSync = true;
    _firstSync = false;
    _completedSyncCount = 0;
    _isSyncRunning.add(true);
    for (final repo in _listRepo) {
      _syncTask(repo);
    }
  }

  void _syncTask(BaseRepository repository) {
    repository.sync(
      onCompleted: (_) => _countSyncStream.add(1),
      onFailed: (_) => _countSyncStream.add(1),
    );
  }

  void _onSyncCountChanged(int count) {
    _completedSyncCount += count;
    if (_completedSyncCount >= _totalSyncTasks) {
      _doingSync = false;
      Future.delayed(_debounceTime, () => _firstSync = true);
      Log.d('Sync done');
      _isSyncRunning.add(false);
    }
  }

  FutureOr<void> syncUsers() async {
    await ezUserRepository.sync();
  }

  FutureOr<void> dispose() async {
    await _syncSubscription.cancel();
    await _sync$.close();
    await _countSyncSubscription.cancel();
    await _countSyncStream.close();
    await _isSyncRunning.close();
    _timer?.cancel();
  }

  void countdown() {
    _timer?.cancel();
    _timer = Timer(_debounceTime, () {});
  }
}
