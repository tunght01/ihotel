import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/feature/settings/dark_mode/cubit/dark_mode_cubit.dart';
import 'package:ihostel/feature/settings/dark_mode/widgets/button_dark_mode.dart';

class DarkModePage extends StatefulWidget {
  const DarkModePage({super.key});

  static const routeName = 'mode';

  @override
  State<DarkModePage> createState() => _DarkModePageState();
}

class _DarkModePageState extends BasePageState<DarkModePage, DarkModeCubit> {
  @override
  Widget buildPage(BuildContext context, AppState state) {
    return Scaffold(
      appBar: const EzAppBar(title: Text('Chế độ tối')),
      body: EzBody(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.d10),
          child: EzCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = AppThemeType.values[index];
                return ButtonDarkMode(
                  title: item.title,
                  isSelected: state.darkMode == item,
                  onPressed: () async => bloc.appCubit.setDarkMode(item),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: AppThemeType.values.length,
            ),
          ),
        ),
      ),
    );
  }
}
