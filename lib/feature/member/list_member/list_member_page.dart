import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/feature/member/list_member/cubit/list_member_cubit.dart';
import 'package:ihostel/feature/member/list_member/widgets/discontinue_tab.dart';
import 'package:ihostel/feature/member/list_member/widgets/used_tab.dart';
import 'package:ihostel/feature/navigation.dart';

class ListMemberPage extends StatefulWidget {
  const ListMemberPage({required this.group, super.key});

  static const routeName = 'list_member';
  final EzGroup group;

  @override
  State<ListMemberPage> createState() => _ListMemberPageState();
}

class _ListMemberPageState extends BasePageState<ListMemberPage, ListMemberCubit> {
  @override
  void initState() {
    bloc.load(widget.group.id);
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context, AppState appState) {
    return Scaffold(
      appBar: EzAppBar(
        title: const Text('Danh sách thành viên'),
        actions: [
          SyncIcon(
            icon: Icons.add_circle_outline_sharp,
            onPressed: () => AddMemberRoute((widget.group, null)).pushOnLy<void>(context),
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
            BlocBuilder<ListMemberCubit, ListMemberState>(
              builder: (context, state) {
                return Expanded(
                  child: EzTabBarView(
                    children: [
                      EzTabView(
                        title: 'Đang sử dụng',
                        child: UsedTab(
                          roomUser: state.usersUsing,
                        ),
                      ),
                      EzTabView(
                        title: 'Ngừng sử dụng',
                        child: DiscontinueTab(
                          roomUser: state.usersDiscontinued,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
