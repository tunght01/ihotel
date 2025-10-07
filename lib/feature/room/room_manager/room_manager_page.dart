import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/feature/navigation.dart';
import 'package:ihostel/feature/room/room.dart';
import 'package:ihostel/feature/room/room_manager/cubit/room_manager_cubit.dart';

class RoomManagerPage extends StatefulWidget {
  const RoomManagerPage({required this.group, super.key});

  static const routeName = 'room_manager';
  final EzGroup group;

  @override
  State<RoomManagerPage> createState() => _RoomManagerPageState();
}

class _RoomManagerPageState extends BasePageState<RoomManagerPage, RoomManagerCubit> {
  @override
  void initState() {
    bloc.load(widget.group);
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context, AppState appState) {
    return BlocBuilder<RoomManagerCubit, RoomManagerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: EzAppBar(
            title: const Text('Quản lý phòng'),
            actions: [
              SyncIcon(
                icon: Icons.add_circle_outline_sharp,
                onPressed: () => CreateRoomRoute(widget.group).pushOnLy<void>(context),
              ),
            ],
          ),
          body: EzBody(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.d10),
                  child: EzTextField(isSearch: true, hint: 'Tìm theo tên'),
                ),
                Expanded(
                  child: EzTabBarView(
                    children: [
                      EzTabView(
                        title: 'Đang ở (${state.roomsStaying.length})',
                        child: AreStayingTab(rooms: state.roomsStaying),
                      ),
                      EzTabView(
                        title: 'Phòng trống (${state.roomsEmpty.length})',
                        child: RoomEmptyTab(rooms: state.roomsEmpty),
                      ),
                    ],
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
