import 'package:flutter/material.dart';

class DismissibleKeyboardContainer extends StatefulWidget {
  const DismissibleKeyboardContainer({
    required this.child, super.key,
  });

  final Widget child;


  @override
  State<DismissibleKeyboardContainer> createState() => _DismissibleKeyboardContainerState();
}

class _DismissibleKeyboardContainerState extends State<DismissibleKeyboardContainer> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Focus(
          focusNode: _focusNode,
          child: const SizedBox.shrink(),
        ),
        GestureDetector(
          onTap: (){
            _focusNode.requestFocus();
            FocusScope.of(context).unfocus();
          },
          child: widget.child,
        ),
      ],
    );
  }
}
