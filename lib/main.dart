import 'package:flutter/material.dart';
import 'package:preflop_trainer/homepage.dart';
import 'package:preflop_trainer/models/card.dart' as models;
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
  List<models.Card> hand = models.Card.random(2);

  void nextHand() {
    hand = models.Card.random(2);
    notifyListeners();
  }
}