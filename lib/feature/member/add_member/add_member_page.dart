import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';
import 'package:ihostel/app/data/models/ez_user/ez_user.dart';
import 'package:ihostel/feature/member/add_member/cubit/add_member_cubit.dart';
import 'package:ihostel/feature/member/add_member/data/add_member.dart';
import 'package:ihostel/feature/navigation.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({
    required this.group,
    this.room,
    super.key,
  });

  static const routeName = 'add_member';
  final EzGroup group;
  final EzGroupRoom? room;

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends BasePageState<AddMemberPage, AddMemberCubit> {
  @override
  void initState() {
    bloc
      ..load(widget.group)
      ..addRoomUser();
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context, AppState appState) {
    return Scaffold(
      appBar: EzAppBar(
        title: const Text('Thêm thành viên'),
        actions: [
          SyncIcon(
            icon: Icons.done,
            onPressed: () => bloc.save(widget.group, onDone: context.pop),
          ),
        ],
      ),
      body: EzBody(
        child: Column(
          children: [
            Text(
              'Thêm nhanh thành viên tại màn hình này với các thông tin cơ bản, các thông tin khác như: sdt, email, liên kết tài khoản có thể cập nhật sau',
              style: EzTextStyles.s12.secondary,
            ),
            Dimens.d25.verticalSpace,
            BlocBuilder<AddMemberCubit, AddMemberState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.roomUser.isNotEmpty,
                  child: Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = state.roomUser[index];
                        if (index == 0) {
                          return EzCard(
                            borderRadius: BorderRadius.circular(Dimens.d10),
                            child: Column(
                              children: [
                                BlocBuilder<AddMemberCubit, AddMemberState>(
                                  builder: (context, state) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: EzTextField(
                                            title: 'Tên',
                                            hasClear: true,
                                            hasLiesOnCard: true,
                                            value: item.firstName,
                                            hint: 'Text',
                                            onChanged: (value) => bloc.onItemRoomChange(item.id, name: value),
                                          ),
                                        ),
                                        Dimens.d10.horizontalSpace,
                                        Expanded(
                                          child: EzTextField(
                                            title: 'Số điện thoại',
                                            hasClear: true,
                                            hasLiesOnCard: true,
                                            hint: 'Số điện thoại',
                                            value: item.phone,
                                            onChanged: (value) => bloc.onItemRoomChange(item.id, phone: value),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Dimens.d15.verticalSpace,
                                CustomDropdownMenu<EzGroupRoom?>(
                                  expandedInsets: EdgeInsets.zero,
                                  menuHeight: 200,
                                  initialSelection: state.allRoom.firstOrNull,
                                  dropdownMenuEntries: state.allRoom.map((room) {
                                    return CustomDropdownMenuEntry<EzGroupRoom>(
                                      value: room,
                                      label: room.name,
                                      style: MenuItemButton.styleFrom(
                                        foregroundColor: AppColors.current.primaryText,
                                      ),
                                    );
                                  }).toList(),
                                  onSelected: (value) => bloc.onItemRoomChange(item.id, room: value),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return EzCard(
                            borderRadius: BorderRadius.circular(Dimens.d10),
                            onDelete: () => bloc.removeRoomUser(item.id),
                            child: Column(
                              children: [
                                BlocBuilder<AddMemberCubit, AddMemberState>(
                                  builder: (context, state) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: EzTextField(
                                            title: 'Tên',
                                            hasClear: true,
                                            hasLiesOnCard: true,
                                            value: item.firstName,
                                            hint: 'Text',
                                            onChanged: (value) => bloc.onItemRoomChange(item.id, name: value),
                                          ),
                                        ),
                                        Dimens.d10.horizontalSpace,
                                        Expanded(
                                          child: EzTextField(
                                            title: 'Số điện thoại',
                                            hasClear: true,
                                            hasLiesOnCard: true,
                                            hint: 'Số điện thoại',
                                            value: item.phone,
                                            onChanged: (value) => bloc.onItemRoomChange(item.id, phone: value),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Dimens.d15.verticalSpace,
                                CustomDropdownMenu<EzGroupRoom?>(
                                  expandedInsets: EdgeInsets.zero,
                                  menuHeight: 200,
                                  initialSelection: state.allRoom.firstOrNull,
                                  dropdownMenuEntries: state.allRoom.map((room) {
                                    return CustomDropdownMenuEntry<EzGroupRoom>(
                                      value: room,
                                      label: room.name,
                                      style: MenuItemButton.styleFrom(
                                        foregroundColor: AppColors.current.primaryText,
                                      ),
                                    );
                                  }).toList(),
                                  onSelected: (value) => bloc.onItemRoomChange(item.id, room: value),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) => Dimens.verticalItem.verticalSpace,
                      itemCount: state.roomUser.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyScaffold).copyWith(bottom: Dimens.paddingSafeArea),
        child: BlocBuilder<AddMemberCubit, AddMemberState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: EzButton.custom(
                    isEnabled: true,
                    onPressed: onPressed(ButtonAddType.brandNew, state.roomUser),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(ButtonAddType.brandNew.title, style: EzTextStyles.s12.primary.w600.copyWith(color: Colors.white)),
                          Dimens.d10.verticalSpace,
                          Text(ButtonAddType.brandNew.content, style: EzTextStyles.s11.secondary.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                Dimens.d10.horizontalSpace,
                Expanded(
                  child: EzButton.custom(
                    isEnabled: true,
                    onPressed: onPressed(ButtonAddType.usedIHostel, state.roomUser),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(ButtonAddType.usedIHostel.title, style: EzTextStyles.s12.primary.w600.copyWith(color: Colors.white)),
                          Dimens.d10.verticalSpace,
                          Text(ButtonAddType.usedIHostel.content, style: EzTextStyles.s11.secondary.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void Function()? onPressed(ButtonAddType type, List<EzGroupRoomUser> roomUsers) {
    if (type.isBrandNew) return bloc.addRoomUser;
    if (type.isUsedIHostel) {
      return () async {
        final ezUser = await LinkAccountRoute().pushOnLy<EzUser?>(context);
        final memberLast = roomUsers.last;

        if (ezUser != null) {
          if (memberLast.firstName.isNotEmpty && memberLast.phone.isNotEmpty) {
            bloc.addRoomUser(user: ezUser);
          } else {
            bloc.onItemRoomChange(memberLast.id, user: ezUser);
          }
        }
      };
    }
    return null;
  }
}
