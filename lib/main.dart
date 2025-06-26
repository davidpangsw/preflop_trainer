import 'package:flutter/material.dart';
import 'package:preflop_trainer/homepage.dart';
import 'package:preflop_trainer/models/pack.dart';
import 'package:preflop_trainer/models/poker/poker_flashcard_deck.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final packId = await loadPackId();
    await loadPack(bundle, packId);
  }

  static Future<String> loadPackId() async {
    const String key = 'packId';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == null) {
      prefs.setString(key, "open/${PokerPosition.utg.name}");
    }

    return prefs.getString(key)!;
  }

  void savePackId(String packId) async {
    const String key = 'packId';
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, packId);
  }

  Future<void> loadPack(AssetBundle bundle, String packId) async {
    pack = await Pack.load(bundle, packId);
    flashcardQuestion = pack!.nextQuestion();
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

  void onSelectPosition(BuildContext context, PokerPosition position) {
    final bundle = DefaultAssetBundle.of(context);
    final packId = "open/${position.name}";
    savePackId(packId);
    loadPack(bundle, packId);
  }
}
