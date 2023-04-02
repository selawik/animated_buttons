import 'package:flutter/material.dart';

class LongPressOverlayButton extends StatefulWidget {
  final Duration longPressDuration;
  final void Function() onLongPressComplete;
  final void Function()? onUsualPress;
  final String title;
  final Color overlayColor;
  final double overlayHeight;

  const LongPressOverlayButton({
    Key? key,
    required this.longPressDuration,
    required this.onLongPressComplete,
    required this.title,
    this.onUsualPress,
    this.overlayColor = Colors.red,
    this.overlayHeight = 36,
  }) : super(key: key);

  @override
  State<LongPressOverlayButton> createState() => _LongPressOverlayButtonState();
}

class _LongPressOverlayButtonState extends State<LongPressOverlayButton>
    with SingleTickerProviderStateMixin {
  final GlobalKey buttonKey = GlobalKey();

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.longPressDuration);

  @override
  void initState() {
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        widget.onLongPressComplete();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onUsualPress,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      child: ElevatedButton(
        key: buttonKey,
        onPressed: null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            var buttonRenderBox =
                buttonKey.currentContext?.findRenderObject() as RenderBox?;

            var buttonWidth = buttonRenderBox?.size.width ??
                MediaQuery.of(context).size.width;

            var buttonHeight =
                buttonRenderBox?.size.height ?? widget.overlayHeight;

            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (_controller.value != 0)
                  Container(
                    color: widget.overlayColor,
                    width: _controller.value * buttonWidth,
                    height: buttonHeight,
                  ),
                Center(child: Text(widget.title))
              ],
            );
          },
        ),
      ),
    );
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _controller.forward();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _controller.reset();
  }
}
