import 'package:flutter/material.dart';

class MixedBox extends StatelessWidget {
  final List<double> percentages;
  final List<Color> colors;

  const MixedBox({super.key, required this.percentages, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 1)
        ),
      child: SizedBox(
        width: double.infinity,
        height: 50, // Adjust height as needed
        
        child: Row(
          children: List.generate(
            percentages.length,
            (i) => Expanded(
              flex: (percentages[i] * 100).toInt(), // Convert percentage to flex
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
