import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../features/settings/presentation/provider/setting_provider.dart';
import '../../../main.dart';

class AnimatedButton extends StatefulWidget {
  final Widget title;
  final VoidCallback onPressed;
  final VoidCallback? onLongPressed;
  final double? height;
  final double? width;
  final double? padding;
  final double? borderRadius;
  final Color? bgColor;
  final BoxBorder? border;
  final bool isBoxShadow;

  const AnimatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.onLongPressed,
    this.height,
    this.width,
    this.borderRadius,
    this.bgColor,
    this.border,
    this.padding,
    required this.isBoxShadow,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  double _scale = 0.0;
  late AnimationController _controller;
  final double _lowerBound = 0.0;
  final double _upperBound = 0.2;
  final _animationMilliseconds = 200;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: _animationMilliseconds,
      ),
      lowerBound: _lowerBound,
      upperBound: _upperBound,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? 80.0;
    final width = widget.width ?? 200.0;
    final bgColor =
        widget.bgColor ?? Theme.of(context).colorScheme.inversePrimary;

    final borderRadius = widget.borderRadius ?? 50.0;

    return GestureDetector(
      onTap: () {
        widget.onPressed();
        final provider = Provider.of<SettingProvider>(context, listen: false);
        if (provider.appSound) {
          generalButtonSound.value.resume();
        }
        _shrinkButton();
        _restoreButton();
      },
      onLongPress: () {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (widget.onLongPressed != null) {
            widget.onLongPressed!();
          }
        });
      },
      onTapDown: (_) => _shrinkButton(),
      onTapCancel: _restoreButton,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (ctx, child) {
          _scale = 1 - _controller.value;
          return Transform.scale(
            scale: _scale,
            child: child,
          );
        },
        child: Container(
          width: width,
          height: height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: widget.isBoxShadow
                ? const [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 5.0,
                      blurRadius: 10.0,
                    )
                  ]
                : null,
          ),
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: Container(
              width: width,
              height: height * .9,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(.2),
                    Colors.white.withOpacity(.35),
                  ],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(child: widget.title),
            ),
          ),
        ),
      ),
    );
  }

  void _shrinkButton() {
    HapticFeedback.mediumImpact();
    _controller.forward();
  }

  void _restoreButton() {
    Future.delayed(
        const Duration(milliseconds: 100), () => _controller.reverse());
  }
}
