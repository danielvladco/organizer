import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingActionList extends StatefulWidget {
  FloatingActionList({
    this.key,
    this.actions,
    this.icon,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.mini = false,
    this.shape = const CircleBorder(),
    this.clipBehavior = Clip.none,
    this.materialTapTargetSize,
    this.isExtended = false,
  }) : super(key: key);

  final IconData icon;
  final List<Widget> actions;
  final Color foregroundColor;
  final Color backgroundColor;
  final ShapeBorder shape;
  final double elevation;
  final Clip clipBehavior;
  final double highlightElevation;
  final bool isExtended;
  final Key key;
  final MaterialTapTargetSize materialTapTargetSize;
  final bool mini;
  final String tooltip;

  @override
  State createState() => new FloatingActionListState();
}

class FloatingActionListState extends State<FloatingActionList>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    super.initState();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(
          widget.actions.length,
          (int index) => Container(
                height: 60.0,
                alignment: FractionalOffset.centerRight,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                        0.0, 1.0 - index / widget.actions.length / 2.0,
                        curve: Curves.easeOut),
                  ),
                  child: widget.actions[index],
                ),
              )).toList()
        ..add(
          Container(
            height: 65.0,
            alignment: FractionalOffset.bottomRight,
            child: FloatingActionButton(
              heroTag: null,
              foregroundColor: widget.foregroundColor,
              backgroundColor: widget.backgroundColor,
              shape: widget.shape,
              elevation: widget.elevation,
              clipBehavior: widget.clipBehavior,
              highlightElevation: widget.highlightElevation,
              isExtended: widget.isExtended,
              materialTapTargetSize: widget.materialTapTargetSize,
              mini: widget.mini,
              tooltip: widget.tooltip,
              child: new AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget child) {
                  return new Transform(
                    transform: new Matrix4.rotationZ(
                        _animationController.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: new Icon(
                        _animationController.isDismissed ? widget.icon : Icons.close),
                  );
                },
              ),
              onPressed: () {
                toggle();
              },
            ),
          ),
        ),
    );
  }

  toggle() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
