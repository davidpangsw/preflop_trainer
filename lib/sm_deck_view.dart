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
    return JsonView.string(
          appState.smDeck!.toMyJson(5),
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
          )
    );
  }

}
