
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:samsung_radio/util/colors.dart';

/// a triangle painter
class _TrianglePainter extends CustomPainter {
  final double lineSize;

  _TrianglePainter({this.lineSize = 16});
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    path.moveTo(0, 0);
    path.addOval(shapeBounds);
    path.lineTo(lineSize, 0);
    path.close();
    Paint paint = Paint();
    paint.color =  UIColors.blue;
    paint.style = PaintingStyle.fill;
    //canvas.rotate( 90 * pi / 180);
    //canvas.translate(-size.width/2, -size.height/2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// The controller for the ruler picker
/// init the ruler value from the controller
/// 用于 RulerPicker 的控制器，可以在构造函数里初始化默认值
class RulerPickerController extends ValueNotifier<num> {
  RulerPickerController({num value = 0.0}) : super(value);
  num get value => super.value;
  set value(num newValue) {
    super.value = newValue;
  }
}

typedef void ValueChangedCallback(num value);

/// RulerPicker 标尺选择器
/// [width] 必须是具体的值，包括父级container的width，不能是 double.infinity，
/// 可以传入MediaQuery.of(context).size.width
class RulerPicker extends StatefulWidget {
  final ValueChangedCallback onValueChange;
  final double width;
  final double height;
  final Color backgroundColor;
  /// the marker on the ruler, default is a arrow
  final Widget marker;
  double _value;
  /// the fraction digits of the picker value
  int fractionDigits;
  RulerPickerController controller;
  RulerPicker({
    @required this.onValueChange,
    @required this.width,
    @required this.height,
    this.backgroundColor = Colors.white,
    this.fractionDigits = 0,
    this.controller,
    this.marker,
  });
  @override
  State<StatefulWidget> createState() {
    return RulerPickerState();
  }
}

// todo 实现 animateTo
class RulerPickerState extends State<RulerPicker> {
  double lastOffset = 0;
  bool isPosFixed = false;
  String value;
  ScrollController scrollController;

  /// default mark
  Widget mark() {
    /// default mark arrow
    Widget triangle() {
      return SizedBox(
        width: 14,
        height: 14,
        child: CustomPaint(
          painter: _TrianglePainter(),
        ),
      );
    }

    return Container(
      child: SizedBox(
        width: 16,
        height: 50,
        child: Stack(
          children: <Widget>[
            Positioned(bottom: 0,left: 0,child: triangle()),
            Container(
              width: 2,
              height: 50,
              margin: EdgeInsets.only(left: 6),
              color:  UIColors.blue
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: Stack(
        children: <Widget>[
          Listener(
            onPointerDown: (event) {
              FocusScope.of(context).requestFocus(new FocusNode());
              isPosFixed = false;
            },
            onPointerUp: (event) {},
            child: NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                } else if (scrollNotification is ScrollUpdateNotification) {
                } else if (scrollNotification is ScrollEndNotification) {
                  if (!isPosFixed) {
                    isPosFixed = true;
                    fixPosition((scrollNotification.metrics.pixels / 10)
                        .roundToDouble() *
                        10);
                    scrollController.notifyListeners();
                  }
                }
                return true;
              },
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    // constraints: BoxConstraints(maxWidth: 10),
                    padding: index == 0
                        ? EdgeInsets.only(
                      left: widget.width / 2,
                    )
                        : EdgeInsets.zero,
                    child: Container(
                      width: 10,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            top: 40,
                            width: 50,
                            left: -25,
                            child: index % 10 == 0
                                ? Container(
                              alignment: Alignment.center,
                              child: Text(
                                "${index.toString()}",
                                style: TextStyle(
                                  color:
                                  Color.fromARGB(255, 188, 194, 203),
                                  fontSize: 8,
                                ),
                              ),
                            )
                                : Container(),
                          ),
                          Positioned(
                            bottom: 20,
                            child:  Container(
                              width: index % 10 == 0 ? 1.5 : 1,
                              height: index % 10 == 0 ? 22 : 10,
                              color: Color.fromARGB(255, 188, 194, 203),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: widget.width / 2 - 6,
            bottom: 5,
            child: widget.marker ?? mark(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      setState(() {
        widget._value = double.parse((scrollController.offset / 10)
            .toStringAsFixed(widget.fractionDigits));
        if (widget._value < 0) widget._value = 0;
        if (widget.onValueChange != null) {
          widget.onValueChange(widget._value);
        }
      });
    });
    widget.controller.addListener(() {
      setPositionByValue(widget.controller.value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void didUpdateWidget(RulerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  /// 滑动后修正标记，使之对齐
  void fixPosition(double curPos) {
    print('curPos: ${curPos}');
    double targetPos =
    double.parse(curPos.toStringAsFixed(widget.fractionDigits));
    print('targetPos: ${targetPos}');
    if (targetPos < 0) targetPos = 0;
    // todo animateTo 异步操作
    scrollController.jumpTo(
      targetPos,
      // duration: Duration(milliseconds: 500),
      // curve: Curves.easeOut,
    );
  }

  /// 根据数值设置标记位置
  void setPositionByValue(num value) {
    num targetPos = value * 10;
    if (targetPos < 0) targetPos = 0;
    scrollController.jumpTo(
      targetPos.toDouble(),
      // duration: Duration(milliseconds: 500),
      // curve: Curves.easeOut,
    );
  }
}
