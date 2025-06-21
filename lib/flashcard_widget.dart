import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/poker_state_widget.dart';
import 'package:provider/provider.dart';

class FlashcardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (appState.pokerState == null)
            ? Text('')
            : PokerStateWidget(pokerState: appState.pokerState!),
        (appState.isPreviousCorrect == null)
            ? Text('')
            : (appState.isPreviousCorrect == true)
            ? Text('Correct!')
            : Text('Wrong!'),
        FlashcardWidgetPanel(),
        JsonView.string(
          appState.smDeck!.toJson(),
          theme: JsonViewTheme(
            keyStyle: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
            doubleStyle: const TextStyle(color: Colors.green),
            intStyle: const TextStyle(color: Colors.green),
            stringStyle: const TextStyle(color: Colors.green),
            boolStyle: const TextStyle(color: Colors.green),
            closeIcon: const Icon(Icons.close, color: Colors.green, size: 20),
            openIcon: const Icon(Icons.add, color: Colors.green, size: 20),
            separator: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.arrow_right_alt_outlined, color: Colors.green),
            ),
          ),
        ),
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
