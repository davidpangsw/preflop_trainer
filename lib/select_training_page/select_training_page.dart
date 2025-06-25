import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:preflop_trainer/select_training_page/hand_chart.dart';
import 'package:provider/provider.dart';

class SelectTrainingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectTrainingPanel(),
          HandChart(),
          (appState.pack == null)
              ? CircularProgressIndicator()
              : JsonView.string(appState.pack!.toBriefJson()),
        ],
      ),
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
    return Row(
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
    );
  }
}
