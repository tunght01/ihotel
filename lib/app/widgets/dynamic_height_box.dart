import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ihostel/app/app.dart';

class DynamicHeightBox extends StatefulWidget {
  const DynamicHeightBox({
    required this.content,
    super.key,
    this.header,
  });

  final Widget? header;
  final Widget content;

  @override
  State<StatefulWidget> createState() {
    return DynamicHeightBoxState();
  }
}

class DynamicHeightBoxState extends State<DynamicHeightBox> {
  GlobalKey<State<StatefulWidget>> contentKey = GlobalKey();
  GlobalKey<State<StatefulWidget>> headerKey = GlobalKey();
  GlobalKey<State<StatefulWidget>> parentKey = GlobalKey();
  bool isMatchParent = false;
  double boxHeight = 0;
  double oldSize = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(_postFrameCallback);
    return Stack(
      key: parentKey,
      children: [
        SizedBox(
          height: boxHeight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.d16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.current.disabledText,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  key: headerKey,
                  child: widget.header ?? Container(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      key: contentKey,
                      child: widget.content,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _postFrameCallback(_) {
    // Calculate if content reached maximum height and switch to full content
    final ct = contentKey.currentContext;
    final parentContext = parentKey.currentContext;
    if (ct == null || parentContext == null || (widget.header != null && headerKey.currentContext == null)) {
      return;
    }

    final newSize = ct.size?.height ?? 0;
    final parentSize = parentContext.size?.height ?? 0;
    final headerSize = widget.header == null ? 0 : (headerKey.currentContext?.size?.height ?? 0);
    final maxHeight = parentSize - headerSize;
    if (newSize >= maxHeight && isMatchParent == false) {
      setState(() {
        isMatchParent = true;
      });
    } else if (newSize < maxHeight && isMatchParent == true) {
      setState(() {
        isMatchParent = false;
      });
    }
    if (boxHeight != min(newSize + headerSize, parentSize)) {
      setState(() {
        boxHeight = min(newSize + headerSize, parentSize);
      });
    }
  }
}
