import 'package:flutter/material.dart';
import 'package:preflop_trainer/action_box.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:provider/provider.dart';
import 'package:preflop_trainer/card_widget.dart';

class FlashcardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    final pokerState = appState.pokerState;

    if (pokerState == null) return CircularProgressIndicator();

    var hand = pokerState.hand;

    return Column(
      children: [
        Text(pokerState.position.name.toUpperCase()),
        Text(pokerState.situation.name.toUpperCase()),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            appState.onResponse(PokerAction.fold); // or check
          },
          child: Text('Fold'),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     appState.answerPokerState(PokerAction.call);
        //   },
        //   child: Text('Call'),
        // ),
        ElevatedButton(
          onPressed: () {
            appState.answerPokerState(PokerAction.raise);
          },
          child: Text('Raise'),
        ),
        ElevatedButton(
          onPressed: () {
            appState.answerPokerState(null);
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

    // if (appState.smDeck == null) return CircularProgressIndicator();
    // final map = {
    //   for (var entry in appState.smDeck!.topEntries(5))
    //     entry.key: {
    //       'interval': entry.value.interval,
    //       'repetitions': entry.value.repetitions,
    //       'easeFactor': entry.value.easeFactor,
    //     },
    // };
    // return JsonView.map(map);
  }
}
