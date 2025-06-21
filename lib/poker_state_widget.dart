import 'package:flutter/material.dart';
import 'package:preflop_trainer/card_widget.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:provider/provider.dart';

class PokerStateWidget extends StatelessWidget {
  final PokerState pokerState;
  const PokerStateWidget({super.key, required this.pokerState});

  @override
  Widget build(BuildContext context) {
    var hand = pokerState.hand;

    return Column(
      children: [
        Text(pokerState.position.name.toUpperCase()),
        Text(pokerState.action.name.toUpperCase()),
        Text(''),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardWidget(card: hand.card2),
            CardWidget(card: hand.card1),
          ],
        ),
      ],
    );
  }
}
