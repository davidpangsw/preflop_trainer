import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preflop_trainer/homepage.dart';
import 'package:preflop_trainer/models/flashcard/flashcard_deck.dart';
import 'package:preflop_trainer/models/flashcard/sm_deck.dart';
import 'package:preflop_trainer/models/playing_card/card.dart' as models;
import 'package:preflop_trainer/models/playing_card/hand.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:provider/provider.dart';
import 'package:spaced_repetition/SmResponse.dart';
import 'package:spaced_repetition/sm.dart';

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
  final Sm sm = Sm();
  FlashcardDeck? flashcardDeck;
  SmDeck? smDeck;
  PokerState? pokerState;
  bool? isPreviousCorrect;

  MyAppState() {
    loadFlashcardDeck("open/utg");
  }

  Future<void> loadFlashcardDeck(String deckId) async {
    print("loading flashcard deck $deckId...");
    flashcardDeck = await _loadFlashcardDeck(deckId);
    smDeck = SmDeck.withDefaultResponses(
      id: deckId,
      deck: flashcardDeck!.solutions.keys.toList(),
    );
    // await Future.delayed(const Duration(seconds: 10));
    // print("flashcard deck loaded");

    final preflopSymbol = smDeck!.topCard!;
    final hand = Hand.randomFromPreflopSymbol(preflopSymbol);
    pokerState = PokerState(position: PokerPosition.utg, action: PokerAction.open, hand: hand);

    notifyListeners();
  }

  static Future<FlashcardDeck> _loadFlashcardDeck(String deckId) async {
    final String jsonString = await rootBundle.loadString('decks/$deckId.json');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    return FlashcardDeck.fromJson(jsonData);
  }

  void answerPokerState(int percentageBB) {
    // get the answer of current state
    // compare the input with the actual answer
    // calculate the grade
    final isCorrect = flashcardDeck!.verifyResponse(pokerState!.hand.toPreflopSymbol(), percentageBB);
    final _ = smDeck!.acceptResponse(isCorrect? SmResponseQuality.perfect : SmResponseQuality.blackout);

    // update flashcard status based on the grade
    // final grade = correct? 5 : 0;
    isPreviousCorrect = isCorrect;

    // take another card
    final newItem = smDeck!.topCard!;
    final newHand = Hand.randomFromPreflopSymbol(newItem);

    pokerState = PokerState(
      position: PokerPosition.utg,
      action: PokerAction.open,
      hand: newHand,
    );

    notifyListeners();
  }
}
