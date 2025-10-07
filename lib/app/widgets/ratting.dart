import 'package:flutter/material.dart';

class EzRatting extends StatefulWidget {
  const EzRatting({
    this.viewOnly = true,
    this.size = 40.0,
    this.selected = 5,
    this.length = 5,
    this.onPressed,
    super.key,
  });

  final void Function(int)? onPressed;
  final bool viewOnly;
  final double size;
  final int length;
  final int selected;

  @override
  State<EzRatting> createState() => _EzRattingState();
}

class _EzRattingState extends State<EzRatting> {
  final _list = <int>[];
  int _selected = 0;
  int _length = 0;

  @override
  void initState() {
    _selected = widget.selected;
    _setLength();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EzRatting oldWidget) {
    if (oldWidget.length != widget.length) {
      _setLength();
    }
    if (oldWidget.selected != widget.selected) {
      _selected = widget.selected;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setLength() {
    if (widget.length < 0) {
      _length = 5;
    } else {
      _length = widget.length;
    }
    final gen = List.generate(_length, (i) => i + 1);
    _list
      ..clear()
      ..addAll(gen);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          _list.length,
          (i) => GestureDetector(
            onTap: () {
              if (!widget.viewOnly) {
                setState(() {
                  _selected = _list[i];
                });
                widget.onPressed?.call(_list[getIndex()]);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: _selected > 0 && ((i + 1) <= _list[getIndex()])
                  ? Icon(
                Icons.star,
                color: Colors.amber,
                size: widget.size,
              )
                  : Icon(
                Icons.star,
                color: Colors.grey,
                size: widget.size,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int getIndex() => _selected >= _list.length
      ? _list.length - 1
      : _selected <= 0
          ? 0
          : _selected - 1;
}
