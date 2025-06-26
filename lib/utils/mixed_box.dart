import 'package:flutter/material.dart';

class MixedBox extends StatelessWidget {
  final List<double> percentages;
  final List<Color> colors;
  final double width, height;

  const MixedBox({
    super.key,
    required this.percentages,
    required this.colors,
    required this.width,
    required this.height,
  }) : assert(percentages.length == colors.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,

        child: Row(
          children: List.generate(
            percentages.length,
            (i) => Expanded(
              flex: (percentages[i] * 100)
                  .toInt(), // Convert percentage to flex
              child: Container(
                color: colors[i], // Apply the corresponding color
              ),
            ),
          ),
        ),
      ),
    );
  }
}
