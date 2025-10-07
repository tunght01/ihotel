import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/feature/member/list_member/data/combine_user_room.dart';
import 'package:ihostel/feature/navigation.dart';
import 'package:ihostel/feature/room/room_details/cubit/room_details_cubit.dart';
import 'package:ihostel/feature/room/room_details/widgets/member_item.dart';

class RoomDetailsPage extends StatefulWidget {
  const RoomDetailsPage({
    required this.room,
    super.key,
  });

  static const routeName = 'room_details';
  final EzGroupRoom room;

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends BasePageState<RoomDetailsPage, RoomDetailsCubit> {
  @override
  void initState() {
    bloc.load(widget.room);
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context, AppState appState) {
    return BlocBuilder<RoomDetailsCubit, RoomDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const EzAppBar(title: Text('Chi tiết phòng')),
          body: EzBody(
            child: Column(
              children: [
                EzCard(
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      EzTitleBox(
                        title: 'Tên phòng',
                        content: widget.room.name,
                      ),
                      EzTitleBox(
                        title: 'Tổng thành viên',
                        content: state.members.length.toString(),
                        hasDivider: false,
                      ),
                    ],
                  ),
                ),
                Dimens.verticalItem.verticalSpace,
                Row(
                  children: [
                    Expanded(child: Text('Thêm thành viên', style: EzTextStyles.titlePrimary)),
                    SyncIcon(
                      icon: Icons.add_circle_outline_sharp,
                      onPressed: () {
                        if (state.group != null) {
                          AddMemberRoute((state.group!, widget.room)).pushOnLy<void>(context);
                        }
                      },
                    ),
                  ],
                ),
                Dimens.verticalItem.verticalSpace,
                Flexible(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final user = state.members[index];
                      final data = CombineUserRoom(room: widget.room, groupRoomUser: user);
                      return MemberItem(roomUser: data);
                    },
                    separatorBuilder: (context, index) => Dimens.verticalItem.verticalSpace,
                    itemCount: state.members.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
