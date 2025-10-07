import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/feature/home/create_hostel/cubit/create_hostel_cubit.dart';

class CreateHostelPage extends StatefulWidget {
  const CreateHostelPage({super.key});

  static const routeName = 'create_hostel';

  @override
  State<CreateHostelPage> createState() => _CreateHostelPageState();
}

class _CreateHostelPageState extends BasePageState<CreateHostelPage, CreateHostelCubit> {
  @override
  Widget buildPage(BuildContext context, AppState appState) {
    return Scaffold(
      appBar: const EzAppBar(
        title: Text('Tạo khu trọ'),
      ),
      body: EzBody(
        child: Column(
          children: [
            EzCard(
              borderRadius: BorderRadius.circular(Dimens.d10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EzTextField(
                    title: 'Tên',
                    isRequired: true,
                    hasClear: true,
                    hint: 'Tên khu trọ',
                    hasLiesOnCard: true,
                    onChanged: bloc.onHostelNameChange,
                  ),
                  Dimens.d20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ngày đóng phí', style: EzTextStyles.s14.primary),
                      EzPill.information(title: 'Chi tiết', onPressed: () {}),
                    ],
                  ),
                  Dimens.d10.verticalSpace,
                  Text(
                    'Có thể đặt ngày đóng phí khác nhau cho từng phòng',
                    style: EzTextStyles.s12.secondary,
                  ),
                  Dimens.d10.verticalSpace,
                  BlocBuilder<CreateHostelCubit, CreateHostelState>(
                    builder: (context, state) {
                      return CustomDropdownMenu<int?>(
                        expandedInsets: EdgeInsets.zero,
                        menuHeight: 200,
                        initialSelection: state.paymentDate,
                        dropdownMenuEntries: <CustomDropdownMenuEntry<int>>[
                          ...List.generate(
                            28,
                            (index) => CustomDropdownMenuEntry<int>(
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
                        onSelected: bloc.onPaymentDateChange,
                      );
                    },
                  ),
                  Dimens.d20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tạo phòng nhanh', style: EzTextStyles.s14.primary),
                      BlocBuilder<CreateHostelCubit, CreateHostelState>(
                        builder: (context, state) {
                          return EzSwitch(
                            isSelected: state.createFastHostel,
                            onSwitch: bloc.onCreateFastHostelChange,
                          );
                        },
                      ),
                    ],
                  ),
                  Dimens.d20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<CreateHostelCubit, CreateHostelState>(
                          builder: (context, state) => state.createFastHostel
                              ? EzTextField.number(
                                  title: 'Số lượng phòng',
                                  hint: 'Số lượng',
                                  hasLiesOnCard: true,
                                  hasClear: true,
                                  value: state.quantity.toString(),
                                  onChanged: (value) => bloc.onQuantityChange(value.toInt()),
                                )
                              : EzTextField.text(
                                  title: 'Tên phòng',
                                  hint: 'Tên phòng',
                                  hasLiesOnCard: true,
                                  value: state.roomName,
                                  hasClear: true,
                                  onChanged: bloc.onRoomNameChange,
                                ),
                        ),
                      ),
                      Dimens.d10.horizontalSpace,
                      Expanded(
                        child: BlocBuilder<CreateHostelCubit, CreateHostelState>(
                          builder: (context, state) {
                            return EzTextField.number(
                              title: 'Tiền phòng 1 tháng',
                              hint: 'Số tiền',
                              hasLiesOnCard: true,
                              value: state.price.toCurrencyFormat(),
                              hasClear: true,
                              onChanged: (value) => bloc.onRoomPriceChange(value.toDoubleCurrency()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Dimens.verticalItem.verticalSpace,
            BlocBuilder<CreateHostelCubit, CreateHostelState>(
              builder: (context, state) {
                return Visibility(
                  visible: !state.createFastHostel,
                  child: Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = state.rooms[index];
                        return EzCard(
                          borderRadius: BorderRadius.circular(Dimens.d10),
                          onDelete: () => bloc.removeRoom(item.id),
                          child: Row(
                            children: [
                              Expanded(
                                child: EzTextField.text(
                                  title: 'Tên phòng',
                                  hint: 'Tên phòng',
                                  hasLiesOnCard: true,
                                  value: item.name,
                                  hasClear: true,
                                  onChanged: (value) => bloc.onItemRoomChange(item.id, name: value),
                                ),
                              ),
                              Dimens.d10.horizontalSpace,
                              Expanded(
                                child: EzTextField.number(
                                  title: 'Tiền phòng 1 tháng',
                                  hint: 'Số tiền',
                                  value: item.price.toCurrencyFormat(),
                                  hasLiesOnCard: true,
                                  hasClear: true,
                                  onChanged: (value) => bloc.onItemRoomChange(item.id, price: value.toDoubleCurrency()),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Dimens.verticalItem.verticalSpace,
                      itemCount: state.rooms.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Dimens.d10),
        child: BlocBuilder<CreateHostelCubit, CreateHostelState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!state.createFastHostel)
                  Expanded(
                    child: EzButton.primaryFilled(
                      isEnabled: true,
                      onPressed: bloc.addRoom,
                      title: 'Thêm phòng',
                    ),
                  ),
                Dimens.d10.horizontalSpace,
                Expanded(
                  child: EzButton.primaryFilled(
                    isEnabled: true,
                    onPressed: () => bloc.save(onDone: context.pop),
                    title: 'Hoàn thành',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
