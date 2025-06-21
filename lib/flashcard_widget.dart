import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/poker_state_widget.dart';
import 'package:preflop_trainer/sm_deck_view.dart';
import 'package:provider/provider.dart';

class FlashcardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    // final pokerState = appState.pokerState!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (appState.pokerState == null) ? Text('') : PokerStateWidget(),
        FlashcardWidgetPanel(),
        (appState.isPreviousCorrect == null)
            ? Text('')
            : (appState.isPreviousCorrect == true)
            ? Text('Correct!')
            : Text('Wrong!'),
        SmDeckView(),
      ],
    );
  }
}

class FlashcardWidgetPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            appState.answerPokerState(0);
          },
          child: Text('Fold'),
        ),
        ElevatedButton(
          onPressed: () {
            appState.answerPokerState(100);
          },
          child: Text('Call'),
        ),
        ElevatedButton(
          onPressed: () {
            appState.answerPokerState(200);
          },
          child: Text('Raise 2BB'),
        ),
        ElevatedButton(
          onPressed: () {
            appState.answerPokerState(250);
          },
          child: Text('Raise 2.5BB'),
        ),
        ElevatedButton(
          onPressed: () {
            appState.answerPokerState(300);
          },
          child: Text('Raise 3BB'),
        ),
      ],
    );
  }
}
