import 'package:flutter/cupertino.dart';
import 'package:ihostel/app/app.dart';

class CommonNewPageProgressIndicator extends StatelessWidget {
  const CommonNewPageProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.d8),
        child: Transform.scale(
          scale: 0.8,
          child: const CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
