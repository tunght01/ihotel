import 'dart:async';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/base/base_error.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/usecase/group_room_use_case.dart';
import 'package:ihostel/feature/home/create_hostel/data/fast_room.dart';
import 'package:injectable/injectable.dart';

part 'create_hostel_cubit.freezed.dart';

@freezed
class CreateHostelState extends BaseCubitState with _$CreateHostelState {
  const factory CreateHostelState({
    @Default(false) bool createFastHostel,
    @Default(1) int paymentDate,
    @Default('') String hostelName,
    @Default('') String roomName,
    @Default(0) double price,
    @Default(0) int quantity,
    @Default([]) List<FastRoom> rooms,
  }) = _CreateHostelState;
}

@injectable
class CreateHostelCubit extends BaseCubit<CreateHostelState> {
  CreateHostelCubit(this._groupRoomUseCase) : super(const CreateHostelState());
  final GroupRoomUseCase _groupRoomUseCase;

  void onCreateFastHostelChange(bool value) {
    emit(state.copyWith(createFastHostel: !value));
  }

  void onPaymentDateChange(int? value) {
    emit(state.copyWith(paymentDate: value ?? 1));
  }

  void onHostelNameChange(String value) {
    emit(state.copyWith(hostelName: value));
  }

  void onQuantityChange(int value) {
    emit(state.copyWith(quantity: value));
  }

  void onRoomNameChange(String value) {
    emit(state.copyWith(roomName: value));
  }

  void onRoomPriceChange(double value) {
    emit(state.copyWith(price: value));
  }

  void onItemRoomChange(String id, {String? name, double? price}) {
    final updatedRooms = state.rooms.map((room) {
      if (room.id == id) {
        return room.copyWith(name: name, price: price);
      } else {
        return room;
      }
    }).toList(growable: true);
    emit(state.copyWith(rooms: []));
    emit(state.copyWith(rooms: updatedRooms));
  }

  void addRoom() {
    final updatedRooms = state.rooms.toList(growable: true);
    emit(state.copyWith(rooms: updatedRooms..add(FastRoom())));
  }

  void removeRoom(String id) {
    final updatedRooms = state.rooms.toList(growable: true)..removeWhere((e) => e.id == id);
    emit(state.copyWith(rooms: updatedRooms));
  }

  FutureOr<void> save({VoidCallback? onDone}) async {
    await runCubitCatching(
      action: () async {
        var rooms = <FastRoom>[];
        if (state.createFastHostel) {
          rooms = List.generate(state.quantity, (i) => FastRoom(name: 'Phòng ${i + 1}', price: state.price));
        } else {
          rooms = [FastRoom(name: state.roomName, price: state.price), ...state.rooms];
        }
        if (rooms.isNotEmpty && rooms.any((e) => e.price > 0 && e.name.isNotEmpty)) {
          await _groupRoomUseCase.createGroupCall(
            group: EzGroup(name: state.hostelName, paymentDate: state.paymentDate),
            rooms: rooms,
            startDate: state.paymentDate,
          );
          onDone?.call();
        } else {
          throw const BaseError(ExceptionType.error, 'Vui lòng nhập đầy đủ thông tin');
        }
      },
      success: 'Tạo khu trọ thành công',
    );
  }
}
