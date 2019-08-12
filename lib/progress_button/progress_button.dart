import 'package:flutter/material.dart';
import 'dart:math' as math;


typedef onButtonPressed<T> = T Function();

enum ButtonState{
  loading,
  error,
  success,
  idle,
}

class ProgressButton extends StatefulWidget {

  static const double borderStrokeWidth = 3.0;

  //
  final double height;
  final double width;
  final Widget child;
  final Widget successWidget;
  final Widget errorWidget;
  final onButtonPressed<Future<ButtonState>> onPressed;
  final Function onSuccessFinished;

  //
  final Color idleColor;
  final Color errorColor;
  final Color successColor;


  ProgressButton({
    this.height,
    this.width,
    @required this.child,
    this.successWidget,
    this.errorWidget,
    @required this.onPressed,
    this.onSuccessFinished,

    //
    this.idleColor = Colors.blue,
    this.errorColor = Colors.red,
    this.successColor = Colors.green,

}) : assert(onPressed != null), assert(child != null);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> with SingleTickerProviderStateMixin{

  AnimationController _animationController;

  bool _firstTap = true;

  bool _animateSwitch;
  double _width;
  double _height;
  Widget _child;
  Color _color;
  Function _onPressed;

  Size _buttonSize;
  ButtonState _state;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    _animationController.addStatusListener((status){
      if(status == AnimationStatus.completed){
        _animateSwitch = false;
        _state = ButtonState.loading;
        setState((){});
      }
      else if(status == AnimationStatus.dismissed){
        if(_state == ButtonState.success) {
          _animateSwitch = false;
          _onPressed = () {
            if (widget.onSuccessFinished != null)
              widget.onSuccessFinished();
          };
          setState((){});
        }
        else if(_state == ButtonState.error){
          _animateSwitch = false;
          _onPressed = () async{
            _animateSwitch = true;
            _animationController.fling(velocity: 1.0);
            setState(() {});

            _state = await widget.onPressed();
            _animateSwitch = true;
            _animationController.fling(velocity: -1.0);
            setState((){});

          };
          setState((){});
        }
      }
    });

    // Set idle variables
    _state = ButtonState.idle;
    _animateSwitch = false;
    _onPressed = () async{

      _animateSwitch = true;
      _animationController.fling(velocity: 1.0);
      setState(() {});

      _state = await widget.onPressed();
      _animateSwitch = true;
      _animationController.fling(velocity: -1.0);
      setState((){});
    };
    super.initState();
  }

  Widget _defaultResultWidget(IconData _iconData){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: FittedBox(
          fit: BoxFit.cover,
          child: Icon(
            _iconData,
            color: Colors.white,
            size: math.min(_buttonSize.width, _buttonSize.height),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    _width = _buttonSize == null ? null : _buttonSize.width;
    _height = _buttonSize == null ? null : _buttonSize.height;
    _child = _animateSwitch ? Container()
        : _state == ButtonState.idle ? widget.child
          : _state == ButtonState.success
            ?  widget.successWidget ?? _defaultResultWidget(Icons.check)
            : widget.errorWidget ??  _defaultResultWidget(Icons.close);

    _color = _state == ButtonState.idle
        ? widget.idleColor
        : _state == ButtonState.success
          ? widget.successColor
          : widget.errorColor;

    if(_state == ButtonState.loading)
      return SizedBox(
        width: math.min(_buttonSize.width, _buttonSize.height),
        height: math.min(_buttonSize.width, _buttonSize.height),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(widget.idleColor),
          backgroundColor: Colors.black.withOpacity(0.3),
          strokeWidth: ProgressButton.borderStrokeWidth,
        ),
      );

    if(_animateSwitch){
      return AnimatedBuilder(
          animation: _animationController,
          builder: (context,child){
            return _borderedContainer(
              color: _color,
              width: _lerp(_width, math.min(_buttonSize.width, _buttonSize.height), _animationController.value),
              height: _lerp(_height, math.min(_buttonSize.width, _buttonSize.height), _animationController.value),
            );
          }
      );
    }
    else{
      return _ProgressButton(
        width: widget.width ?? _width,
        height: widget.height ?? _height,
        color: _color,
        child: _child,
        onPressed: (){
          if(_firstTap){
            RenderBox renderBox = context.findRenderObject();
            _buttonSize = renderBox.size;
            _firstTap = false;
          }
          _onPressed();
        },
      );
    }

  }

  Widget _borderedContainer({Color color, double height, double width}){
    return Container(
      height: height,
      width: width,
      decoration: ShapeDecoration(
          shape: _OverRoundedRectangleBorder(
            side: BorderSide(
              color: color,
              width: ProgressButton.borderStrokeWidth,
            ),
            style: PaintingStyle.stroke,
          )
      ),
    );

  }

  double _lerp(double a, double b,double t) =>(b - a) * t + a;

}


class _ProgressButton extends StatefulWidget {

  final Widget child;
  final double height;
  final double width;
  final Function onPressed;

  //
  final Color color;

  _ProgressButton({
    this.child,
    this.width,
    this.height,
    @required this.onPressed,

    //
    this.color,
});

  @override
  __ProgressButtonState createState() => __ProgressButtonState();

}

class __ProgressButtonState extends State<_ProgressButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: ShapeDecoration(
            shape: _OverRoundedRectangleBorder(
              side: BorderSide(color: widget.color,),
              style: PaintingStyle.fill,
            )
        ),
        child: widget.child,
      ),
    );
  }

}

class _OverRoundedRectangleBorder extends ShapeBorder {

  final BorderSide side;
  final PaintingStyle style;

  _OverRoundedRectangleBorder({
    this.side,
    this.style,
  });

  Path _getPath(Rect rect){
    double _radius = rect.height/2;
    Offset _topLeft = rect.topLeft;

    return Path()
      ..moveTo(_topLeft.dx, _topLeft.dy)
      ..relativeMoveTo(_radius, 0.0)
      ..relativeLineTo(rect.width - 2 * _radius, 0.0)
      ..relativeArcToPoint(Offset(0.0, rect.height),radius: Radius.circular(_radius))
      ..relativeLineTo(- (rect.width - 2 * _radius), 0.0)
      ..relativeArcToPoint(Offset(0.0, - rect.height),radius: Radius.circular(_radius))
      ..close();

  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);


  @override
  ShapeBorder scale(double t) => _OverRoundedRectangleBorder(side: side.scale(t));


  @override
  ShapeBorder lerpFrom(ShapeBorder a, double t) {
    assert(t != null);
    if (a is _OverRoundedRectangleBorder) {
      return _OverRoundedRectangleBorder(
        side: BorderSide.lerp(a.side, side, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder lerpTo(ShapeBorder b, double t) {
    assert(t != null);
    if (b is _OverRoundedRectangleBorder) {
      return _OverRoundedRectangleBorder(
        side: BorderSide.lerp(side, b.side, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) => _getPath(rect);


  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection })  => _getPath(rect);


  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {
    Path _path = _getPath(rect);
    Paint paint = new Paint()
      ..color = side.color
      ..style = style
      ..strokeWidth = side.width;
    canvas.drawPath(_path,paint);
  }
}
