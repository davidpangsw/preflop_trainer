import 'package:flutter/material.dart';
import 'package:preflop_trainer/card_widget.dart';
import 'package:preflop_trainer/hand_chart.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/models/card.dart' as models;
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.hand.sort();

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(title),
      // ),
      body: Center(
        child: Column(
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardWidget(card: appState.hand[1]),
                CardWidget(card: appState.hand[0]),
              ],
            ),
            ElevatedButton(onPressed: () {
              appState.nextHand();
            }, child: Text('Next Hand')),
            // HandChart(),
          ],
        ),
      ),
    );
  }
}
