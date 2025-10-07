import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/feature/settings/language/cubit/language_cubit.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  static const routeName = 'language';

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends BasePageState<LanguagePage, LanguageCubit> {
  @override
  Widget buildPage(BuildContext context, AppState state) {
    return Scaffold(
      appBar: const EzAppBar(title: Text('Language')),
      body: EzBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EzTextField.text(isSearch: true, hint: 'Tìm kiếm theo tên'),
            Dimens.d10.verticalSpace,
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.d10),
              child: EzCard(
                padding: EdgeInsets.zero,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = S.delegate.supportedLocales[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Text(item.flagEmoji),
                          Dimens.d8.horizontalSpace,
                          Text(item.languageName, style: EzTextStyles.s14.primary.w500),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: S.delegate.supportedLocales.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
