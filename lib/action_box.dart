import 'package:flutter/material.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:preflop_trainer/utils/mixed_box.dart';

class ActionBox extends StatelessWidget {
  final Map<PokerAction, double> percentages;

  const ActionBox({super.key, required this.percentages});

  @override
  Widget build(BuildContext context) {
    return MixedBox(
      percentages: [
        percentages[PokerAction.fold] ?? 0,
        percentages[PokerAction.check] ?? 0,
        percentages[PokerAction.call] ?? 0,
        percentages[PokerAction.raise] ?? 0,
      ],
      colors: [Colors.blue, Colors.blue, Colors.green, Colors.red],
    );
  }
}
