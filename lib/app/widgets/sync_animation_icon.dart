import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/usecase/sync_use_case.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

class SyncAnimationIcon extends StatefulWidget {
  const SyncAnimationIcon({super.key});

  @override
  State<SyncAnimationIcon> createState() => _SyncAnimationIconState();
}

class _SyncAnimationIconState extends State<SyncAnimationIcon> with TickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  final bloc = getIt<SyncUseCase>();
  late final StreamSubscription<bool> _isSyncEvent;
  final _isSynchronizing = ValueNotifier(false);

  @override
  void initState() {
    _isSyncEvent = bloc.isSyncRunning.listen(
      (event) {
        _isSynchronizing.value = event;
        if (event) {
          if (_controller.duration != null) _controller.repeat();
        } else {
          _controller.reset();
        }
      },
    );
    super.initState();
    _updateStatus();
  }

  Future<void> _updateStatus() async {
    final isSynchronizing = await bloc.isSyncRunning.first;
    _isSynchronizing.value = isSynchronizing;
    if (isSynchronizing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.duration != null) {
          _controller.repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    _isSyncEvent.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EzRippleEffect(
      onPressed: bloc.syncAll,
      borderRadius: BorderRadius.circular(15),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isSynchronizing,
        builder: (context, isSync, child) {
          final color = isSync ? AppColors.current.error : Theme.of(context).iconTheme.color;
          return Padding(
            padding: const EdgeInsets.all(6),
            child: Lottie.asset(
              Assets.animations.syncData,
              width: Dimens.d30,
              height: Dimens.d30,
              delegates: LottieDelegates(
                text: (initialText) => '**$initialText**',
                values: [
                  ValueDelegate.color(
                    const ['Layer 1/cloud-sync Outlines', 'Group 1', 'Fill 1'],
                    value: color,
                  ),
                  ValueDelegate.color(
                    const ['main_library_shelf_icon_sync Outlines', 'Group 1', 'Fill 1'],
                    value: color,
                  ),
                  ValueDelegate.color(
                    const ['main_library_shelf_icon_sync Outlines', 'Group 2', 'Fill 1'],
                    value: color,
                  ),
                ],
              ),
              controller: _controller,
              onLoaded: (composition) {
                _controller.duration = composition.duration;
                if (isSync) {
                  _controller.repeat();
                }
              },
              repeat: true,
            ),
          );
        },
      ),
    );
  }
}
