// Mainly used in the premium template on the promotion line below highlights

import 'package:flutter/material.dart';

class MovingText extends StatefulWidget {
  final String text;

  const MovingText({super.key, required this.text});

  @override
  _MovingTextState createState() => _MovingTextState();
}

class _MovingTextState extends State<MovingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Adjust the animation duration
      vsync: this,
    )..repeat(reverse: false); // Repeat the animation

    // Sets the animation to move from the right to the left
    _animation = Tween<double>(begin: 1.0, end: -1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    // Restart the animation when it completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.forward(from: 0.0); // Restart from the beginning
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset:
              Offset(MediaQuery.of(context).size.width * _animation.value, 0),
          child: child,
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        color: Colors.black45,
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
