import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/feature/room/create_room/cubit/create_room_cubit.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({required this.group, super.key});

  static const routeName = 'create_room';

  final EzGroup group;

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends BasePageState<CreateRoomPage, CreateRoomCubit> {
  @override
  void initState() {
    bloc.load(widget.group);
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context, AppState appState) {
    return Scaffold(
      appBar: const EzAppBar(title: Text('Tạo phòng')),
      body: EzBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EzCard(
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  EzTitleBox(
                    title: 'Tên Nhà Trọ',
                    content: widget.group.name,
                  ),
                  BlocBuilder<CreateRoomCubit, CreateRoomState>(
                    builder: (context, state) {
                      return EzTitleBox(
                        title: 'Tổng số phòng',
                        content: state.countRoom.toString(),
                        hasDivider: false,
                      );
                    },
                  ),
                ],
              ),
            ),
            Dimens.d10.verticalSpace,
            EzTextField.text(
              title: 'Tên phòng',
              hint: 'Tên phòng',
              hasClear: true,
              onChanged: bloc.onRoomNameChange,
            ),
            Dimens.d10.verticalSpace,
            BlocBuilder<CreateRoomCubit, CreateRoomState>(
              builder: (context, state) {
                return EzTextField.number(
                  title: 'Tiền phòng 1 tháng',
                  hint: 'Số tiền',
                  value: state.price.toCurrencyFormat(),
                  hasClear: true,
                  onChanged: (value) => bloc.onPriceChange(value.toDoubleCurrency()),
                );
              },
            ),
            Dimens.d10.verticalSpace,
            Text('Ngày đóng phí', style: EzTextStyles.defaultPrimary.copyWith(fontWeight: FontWeight.w600)),
            Dimens.d10.verticalSpace,
            CustomDropdownMenu<int?>(
              expandedInsets: EdgeInsets.zero,
              menuHeight: 200,
              initialSelection: 1,
              dropdownMenuEntries: <CustomDropdownMenuEntry<int>>[
                ...List.generate(
                  28,
                      (index) =>
                      CustomDropdownMenuEntry<int>(
                        value: index + 1,
                        label: 'Ngày ${index + 1}',
                        style: MenuItemButton.styleFrom(
                          foregroundColor: AppColors.current.primaryText,
                        ),
                      ),
                ),
                CustomDropdownMenuEntry(
                  value: 29,
                  label: 'Cuối tháng',
                  style: MenuItemButton.styleFrom(
                    foregroundColor: AppColors.current.primaryText,
                  ),
                ),
              ].toList(),
              onSelected: (value) => bloc.onPaymentDayChange(value ?? 1),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyScaffold).copyWith(
          bottom: Dimens.paddingSafeArea,
        ),
        child: EzButton.primaryFilled(
          onPressed: () => bloc.save(widget.group, context.pop),
          isEnabled: true,
          title: 'Lưu',
        ),
      ),
    );
  }
}
