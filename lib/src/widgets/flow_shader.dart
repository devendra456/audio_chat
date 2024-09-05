import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FlowShader extends StatelessWidget {
  const FlowShader({super.key,required this.child,this.flowColors = const <Color>[Colors.white, Colors.black],});
  final Widget child;
  final List<Color> flowColors;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(colors: flowColors),
      child: child,
    );
  }
}
