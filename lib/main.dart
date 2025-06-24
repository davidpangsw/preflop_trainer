import 'package:flutter/material.dart';
import 'package:preflop_trainer/homepage.dart';
import 'package:preflop_trainer/models/pack.dart';
import 'package:preflop_trainer/models/poker/poker_flashcard_deck.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
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
      create: (context) => MyAppState(context),
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
  Pack? pack;
  PokerState? flashcardQuestion; // current game state to display
  FlashcardResult? flashcardResult; // result of current flashcard

  MyAppState(BuildContext context) {
    // loadFlashcardDeck(context, "open/utg");
    loadPack(context, "open/utg");
  }

  Future<void> loadPack(BuildContext context, String packId) async {
    pack = await Pack.load(context, packId);
    flashcardQuestion = pack!.nextQuestion();
    notifyListeners();
  }

  void onResponse(PokerAction? action) {
    // do not update if no pack is available
    if (pack == null) return;

    // do not update if previous result is still available
    if (flashcardResult != null) return;

    flashcardResult = pack!.acceptResponse(action);

    notifyListeners();
  }

  void nextFlashcard() {
    if (pack == null) return;

    flashcardResult = null; // clear previous result
    flashcardQuestion = pack!.nextQuestion();

    notifyListeners();
  }

  void onReduceDue(Duration duration) {
    if (pack == null) return;

    pack!.reduceDue(duration);
    flashcardResult = null; // clear previous result
    flashcardQuestion = pack!.nextQuestion();

    notifyListeners();
  }
}
