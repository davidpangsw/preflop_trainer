import 'package:flutter/material.dart';
import 'package:preflop_trainer/action_box.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:provider/provider.dart';
import 'package:preflop_trainer/card_widget.dart';

class FlashcardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    if (appState.pack == null) return CircularProgressIndicator();
    final nextDue = appState.pack!.nextDue;
    if (nextDue == null) return Text('No cards');

    if (nextDue.isAfter(DateTime.now())) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Next Due Card at $nextDue'),
        ElevatedButton(
          onPressed: () {
            appState.onReduceDue(Duration(days: 1));
          },
          child: Text('Reduce one day'),
        ),
      ],
    );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [PokerStateWidget(), PanelWidget(), AnswerWidget()],
    );
  }
}

class PokerStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final pokerState = appState.flashcardQuestion;

    if (pokerState == null) return CircularProgressIndicator();

    var hand = pokerState.hand;

    return Column(
      children: [
        Text(pokerState.position.name.toUpperCase()),
        Text(pokerState.situation.name.toUpperCase()),
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

class PanelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.flashcardResult != null) {
      return ElevatedButton(
        onPressed: () {
          appState.nextFlashcard();
        },
        child: Text('Next'),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 50.0,
      children: [
        ElevatedButton(
          onPressed: () {
            appState.onResponse(PokerAction.fold); // or check
          },
          child: Text('Fold'),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     appState.onResponse(PokerAction.call);
        //   },
        //   child: Text('Call'),
        // ),
        ElevatedButton(
          onPressed: () {
            appState.onResponse(PokerAction.raise);
          },
          child: Text('Raise'),
        ),
        ElevatedButton(
          onPressed: () {
            appState.onResponse(null);
          },
          child: Text('I am not sure.'),
        ),
      ],
    );
  }
}

class AnswerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    //  return CircularProgressIndicator();
    if (appState.flashcardResult == null) return Text('');
    final result = appState.flashcardResult!;
    return Column(
      children: [
        Text(
          (result.isCorrect) ? 'Correct!' : 'Wrong!',
          style: TextStyle(
            color: result.isCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        ActionBox(percentages: result.solution),
      ],
    );
  }
}
