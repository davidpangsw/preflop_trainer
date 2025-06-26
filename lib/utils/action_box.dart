import 'package:flutter/material.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:preflop_trainer/utils/mixed_box.dart';

class ActionBox extends StatelessWidget {
  final String hand;
  final Map<PokerAction, double> percentages;

  const ActionBox({super.key, required this.hand, required this.percentages});

  @override
  Widget build(BuildContext context) {
    String msg = hand;
    double total = 100;
    if (percentages.containsKey(PokerAction.raise)) {
      msg += '\nRaise: ${percentages[PokerAction.raise]}%';
      total -= percentages[PokerAction.raise]!;
    } else if (percentages.containsKey(PokerAction.call)) {
      msg += '\nCall: ${percentages[PokerAction.call]}%';
      total -= percentages[PokerAction.call]!;
    } else if (percentages.containsKey(PokerAction.check)) {
      msg += '\nCheck: ${percentages[PokerAction.check]}%';
      total -= percentages[PokerAction.check]!;
    }
    
    if (total > 0) {
      percentages[PokerAction.fold] = total;
      msg += '\nFold: ${percentages[PokerAction.fold]}%';
    }

    return Tooltip(
      message: msg,
      // message: '',
      child: MixedBox(
        percentages: [
          percentages[PokerAction.raise] ?? 0,
          percentages[PokerAction.call] ?? 0,
          percentages[PokerAction.check] ?? 0,
          percentages[PokerAction.fold] ?? 0,
        ],
        colors: [Colors.red, Colors.green, Colors.blue, Colors.blue],
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
