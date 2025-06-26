import 'package:flutter/material.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:preflop_trainer/utils/action_box.dart';
import 'package:provider/provider.dart';

class PanelWidget extends StatelessWidget {
  Widget _button(MyAppState appState, PokerAction? action) {
    return ElevatedButton(
      onPressed: () {
        appState.onResponse(action);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: (action == null) ? Colors.black : action.color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, double.infinity),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Text((action == null) ? 'I am not sure.' : action.displayName),
    );
  }

  Text text(String data, Color? color) {
    return Text(
      data,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final result = appState.flashcardResult;

    // answer widget
    final Widget answerWidget;
    if (result == null) {
      answerWidget = text('Choose', null);
    } else {
      if (result.isCorrect) {
        answerWidget = text('Correct!', Colors.green);
      } else {
        answerWidget = Column(
          children: [
            text('Wrong!', Colors.red),
            ElevatedButton(
              onPressed: () {
                appState.onNextFlashcard();
              },
              child: Text('Next'),
            ),
            ActionBox(hand: result.hand, percentages: result.solution),
          ],
        );
      }
    }

    final buttons = (result != null && !result.isCorrect)
        ? []
        : [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _button(appState, PokerAction.raise)),
                  Expanded(child: _button(appState, PokerAction.fold)),
                ],
              ),
            ),
            Expanded(child: _button(appState, null)),
          ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [answerWidget, ...buttons],
      // children: [],
    );
  }
}
