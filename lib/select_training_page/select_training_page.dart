import 'package:flutter/material.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:preflop_trainer/select_training_page/hand_chart.dart';
import 'package:preflop_trainer/utils/confirmation_button.dart';
import 'package:provider/provider.dart';

class SelectTrainingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.pack == null) return CircularProgressIndicator();
    final pack = appState.pack!;
    final positionText = pack.flashcardDeck.settings.position.name.toUpperCase();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      // direction: Axis.vertical ,
      spacing: 0,
      children: [
        Text(
          positionText,
          style: TextStyle(fontSize: 20.0),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ConfirmationButton(
            buttonText: Text(
              'Reset Memory',
              style: TextStyle(color: Colors.red),
            ),
            dialogContent: 'WARNING: This will erase all memory of this deck: $positionText',
            onConfirm: () => {appState.onResetPackMemory()},
          ),
        ),
        Expanded(
          child: Container(padding: EdgeInsets.all(20.0), child: HandChart()),
        ),
        SelectTrainingPanel(),
        // (appState.pack == null)
        //     ? CircularProgressIndicator()
        //     : JsonView.string(appState.pack!.toBriefJson()),
        Text(
          '100 Stack, NL50, GTO cash game, only opening.\nMore situation will be available in the future.\nIf you are want more features, feel free to contact me!',
        ),
      ],
    );
  }
}

class SelectTrainingPanel extends StatelessWidget {
  Widget button(BuildContext context, String text, PokerPosition position) {
    var appState = context.watch<MyAppState>();
    return ElevatedButton(
      onPressed: () => {appState.onSelectPosition(context, position)},
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            button(context, 'utg', PokerPosition.utg),
            // button(context, 'utg1', PokerPosition.utg1),
            // button(context, 'utg2', PokerPosition.utg2),
            // button(context, 'lj', PokerPosition.lj),
            button(context, 'hj', PokerPosition.hj),
            button(context, 'co', PokerPosition.co),
            button(context, 'btn', PokerPosition.btn),
            button(context, 'sb', PokerPosition.sb),
            // button(context, 'bb', PokerPosition.bb),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [ElevatedButton(onPressed: () => {}, child: Text('open'))],
        ),
      ],
    );
  }
}
