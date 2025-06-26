import 'package:flutter/material.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/utils/card_widget.dart';
import 'package:provider/provider.dart';

class PokerStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final pokerState = appState.flashcardQuestion;

    if (pokerState == null) return CircularProgressIndicator();

    var hand = pokerState.hand;
    // print(pokerState.position.toString());

    return Column(
      children: [
        Text(
          textScaler: TextScaler.linear(2),
          pokerState.position.name.toUpperCase(),
        ),
        Text(
          textScaler: TextScaler.linear(2),
          pokerState.situation.name.toUpperCase(),
        ),
        Text('${appState.pack!.dueCards.length} left'),
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
