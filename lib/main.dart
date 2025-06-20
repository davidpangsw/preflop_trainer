import 'package:flutter/material.dart';
import 'package:preflop_trainer/homepage.dart';
import 'package:preflop_trainer/models/card.dart' as models;
import 'package:preflop_trainer/models/hand.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Preflop Trainer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'Preflop Trainer Home Page'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  PokerState pokerState = PokerState(
    position: PokerPosition.utg,
    action: PokerAction.open,
    hand: Hand.random(),
  );

  void nextHand() {
    pokerState = PokerState(
      position: PokerPosition.utg,
      action: PokerAction.open,
      hand: Hand.random(),
    );
    notifyListeners();
  }
}

class PokerState {
  PokerPosition position;
  PokerAction action;
  Hand hand;

  PokerState({
    required this.position,
    required this.action,
    required this.hand,
  });
}

enum PokerPosition {
  utg,
  utg1, // >= 9
  utg2, // >= 8
  lj, // >= 7
  hj,
  co,
  btn,
  sb,
  bb,
}

enum PokerAction { open, threebet, fourbet }
