import 'package:flutter/material.dart';
import 'package:preflop_trainer/card_widget.dart';
import 'package:preflop_trainer/main.dart';
import 'package:provider/provider.dart';

class PokerStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var hand = appState.pokerState.hand;

    return Column(
      children: [
        Text(appState.pokerState.position.name.toUpperCase()),
        Text(appState.pokerState.action.name.toUpperCase()),
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
