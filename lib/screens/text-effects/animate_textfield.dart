import 'package:flutter/material.dart';
import 'package:here/screens/text-effects/custom_animate_border.dart';

class AnimatedTextField extends StatefulWidget {
  final String label;
  final Widget? suffix;
  const AnimatedTextField({Key? key, required this.label, required this.suffix})
      : super(key: key);

  @override
  AnimatedTextFieldState createState() => AnimatedTextFieldState();
}

class AnimatedTextFieldState extends State<AnimatedTextField> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  late Animation<double> alpha;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    final Animation<double> curve =
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut);
    alpha = Tween(begin: 0.0, end: 1.0).animate(curve);
    
    // controller?.forward();
    _controller?.addListener(() {
      setState(() {});
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _controller?.forward();
      } else {
        _controller?.reverse();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose of the AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Theme(
        data: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color.fromARGB(255, 0, 113, 212),
                )),
        child: CustomPaint(
          painter: CustomAnimateBorder(alpha.value),
          child: TextField(
            focusNode: focusNode,
            decoration: InputDecoration(
              label: Text(widget.label, style: const TextStyle(color: Color.fromARGB(255, 171, 171, 171),),),
              border: InputBorder.none,
              contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: widget.suffix,
            ),
          ),
        ),
      ),
    );
  }
}
