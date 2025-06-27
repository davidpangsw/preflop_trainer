import 'package:flutter/material.dart';
import 'package:preflop_trainer/homepage.dart';
import 'package:preflop_trainer/models/pack.dart';
import 'package:preflop_trainer/models/poker/poker_flashcard_deck.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:preflop_trainer/utils/io.dart';
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
    _init(context);
  }

  void _init(BuildContext context) async {
    final bundle = DefaultAssetBundle.of(context);
    final packId = await MyIO.loadOrNew('packId', "open/${PokerPosition.utg.name}");
    await loadPack(bundle, packId);
  }

  Future<void> loadPack(AssetBundle bundle, String packId) async {
    pack = await Pack.load(bundle, packId);
    _nextFlashcard();
    notifyListeners();
  }

  void onResponse(PokerAction? action) {
    // do not update if no pack is available
    if (pack == null) return;

    flashcardResult = pack!.acceptResponse(action);

    if (flashcardResult!.isCorrect) {
      // keep previous result
      flashcardQuestion = pack!.nextQuestion();
    }

    notifyListeners();
  }

  void onNextFlashcard() {
    if (pack == null) return;
    _nextFlashcard();
    notifyListeners();
  }

  void onReduceDue(Duration duration) {
    if (pack == null) return;

    pack!.reduceDue(duration);
    flashcardResult = null; // clear previous result
    flashcardQuestion = pack!.nextQuestion();

    notifyListeners();
  }

  void onSelectPosition(BuildContext context, PokerPosition position) {
    final bundle = DefaultAssetBundle.of(context);
    final packId = "open/${position.name}";
    MyIO.save('packId', packId);
    loadPack(bundle, packId);
  }

  void onResetPackMemory() async {
    if (pack == null) return;
    await pack!.resetMemory();
    _nextFlashcard();
    notifyListeners();
  }

  void _nextFlashcard() {
    flashcardResult = null; // clear previous result
    flashcardQuestion = pack!.nextQuestion(); // next question
  }
}
