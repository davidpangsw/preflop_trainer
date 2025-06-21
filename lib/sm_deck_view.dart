import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:preflop_trainer/main.dart';
import 'package:provider/provider.dart';

class SmDeckView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    //  return CircularProgressIndicator();
    if (appState.smDeck == null) return CircularProgressIndicator();

    final map = {
      for (var entry in appState.smDeck!.topEntries(5))
        entry.key: {
          'interval': entry.value.interval,
          'repetitions': entry.value.repetitions,
          'easeFactor': entry.value.easeFactor,
        },
    };
    return JsonView.map(map);
  }
}
