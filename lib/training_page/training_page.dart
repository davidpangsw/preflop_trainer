import 'package:flutter/material.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/training_page/panel_widget.dart';
import 'package:preflop_trainer/training_page/poker_state_widget.dart';
import 'package:provider/provider.dart';

class TrainingPage extends StatelessWidget {
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
          // ConfirmationButton(
          //   buttonText: Text('Reduce 1 day'),
          //   dialogContent: 'This may interrupt your learning. Are you sure?',
          //   onConfirm: () {
          //     appState.onReduceDue(Duration(days: 1));
          //   },
          // ),
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
      // Column is also a layout widget. It takes a list of children and
      // arranges them vertically. By default, it sizes itself to fit its
      // children horizontally, and tries to be as tall as its parent.
      //
      // Column has various properties to control how it sizes itself and
      // how it positions its children. Here we use mainAxisAlignment to
      // center the children vertically; the main axis here is the vertical
      // axis because Columns are vertical (the cross axis would be
      // horizontal).
      //
      // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
      // action in the IDE, or press "p" in the console), to see the
      // wireframe for each widget.
      mainAxisAlignment: MainAxisAlignment.start,
      // children: [
      //   FlashcardWidget(),
      // ],
      children: [
        PokerStateWidget(),
        Expanded(child: PanelWidget()),
      ],
    );
  }
}
