import 'dart:async';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/base/base_error.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/repository/ez_group_room/ez_group_room_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'create_room_cubit.freezed.dart';

@freezed
class CreateRoomState extends BaseCubitState with _$CreateRoomState {
  const factory CreateRoomState({
    @Default('') String roomName,
    @Default(0) double price,
    @Default(1) int paymentDay,
    @Default(0) int countRoom,
  }) = _CreateRoomState;
}

@injectable
class CreateRoomCubit extends BaseCubit<CreateRoomState> {
  CreateRoomCubit(this._ezGroupRoomRepository) : super(const CreateRoomState());
  final EzGroupRoomRepository _ezGroupRoomRepository;
  late StreamSubscription<List<List<dynamic>>> _roomStreamSubscription;

  Future<void> load(EzGroup group) async {
    _roomStreamSubscription = CombineLatestStream<List<dynamic>, List<List<dynamic>>>(
      [
        _ezGroupRoomRepository.getRoomsByGroupIdStream(group.id),
      ],
      (values) => values,
    ).listen((values) {
      final rooms = values[0].map((e) => e as EzGroupRoom).toList();
      emit(state.copyWith(countRoom: rooms.length));
    });
  }

  void onRoomNameChange(String value) {
    emit(state.copyWith(roomName: value));
  }

  void onPriceChange(double value) {
    emit(state.copyWith(price: value));
  }

  void onPaymentDayChange(int value) {
    emit(state.copyWith(paymentDay: value));
  }

  Future<void> save(EzGroup group, VoidCallback? onDone) async {
    await runCubitCatching(
      action: () async {
        if (state.roomName.isEmpty || state.price <= 0) {
          throw const BaseError(ExceptionType.error, 'Vui lòng nhập đầy đủ thông tin');
        }

        final room = EzGroupRoom(
          startDate: state.paymentDay,
          price: state.price,
          name: state.roomName,
          groupId: group.id,
          creatorId: appCubit.localStorageDataSource.userId,
        );

        _ezGroupRoomRepository.insert(room);
        onDone?.call();
      },
      success: 'Tạo phòng thành công',
    );
  }

  @override
  Future<void> close() {
    _roomStreamSubscription.cancel();
    return super.close();
  }
}
