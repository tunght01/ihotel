import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';
import 'package:ihostel/app/data/repository/ez_group_room_user/ez_group_room_user_repository.dart';
import 'package:ihostel/app/data/source/local_storage_data_source.dart';
import 'package:injectable/injectable.dart';

@injectable
class MemberGroupUseCase {
  MemberGroupUseCase(this._ezGroupRoomUserRepository, this._localStorageDataSource);

  final EzGroupRoomUserRepository _ezGroupRoomUserRepository;
  final LocalStorageDataSource _localStorageDataSource;

  Future<void> createMemberRoomCall({
    required EzGroup ezGroup,
    required List<EzGroupRoomUser> roomUsers,
  }) async {
    final list = roomUsers
        .map(
          (e) => e.copyWith(
            groupId: ezGroup.id,
            creatorId: _localStorageDataSource.userId,
          ),
        )
        .toList(growable: true);
    _ezGroupRoomUserRepository.insertList(list);
  }
}
