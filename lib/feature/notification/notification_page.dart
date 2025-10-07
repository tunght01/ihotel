import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:ihostel/feature/notification/widget/notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static const routeName = 'notification';

  @override
  State<NotificationPage> createState() => _ListMemberPageState();
}

class _ListMemberPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EzAppBar(
        title: const Text('Thông báo'),
        actions: [
          EzRippleEffect(
            child: Assets.images.icArchiveTick.svg(),
            onPressed: () {},
          ),
        ],
      ),
      body: EzBody(
        child: SizedBox(
          width: double.infinity,
          child: ListView.separated(
            itemCount: 3,
            itemBuilder: (context, index) {
              return NotificationItem(
                title: 'Nhà vc anh Khải',
                content: 'Hoàn tất thu tiền phòng 1',
                date: DateTime.now(),
                onTap: () {},
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ),
    );
  }
}
