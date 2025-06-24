import 'package:preflop_trainer/models/poker/poker_state.dart';

// Corresponding one 'xxx.json' file
class PokerFlashcardDeck {
  final FlashcardDeckSettings settings;
  // final Map<String, dynamic> settings;
  final Map<String, Solution> solutions;

  PokerFlashcardDeck({required this.settings, required this.solutions});

  factory PokerFlashcardDeck.fromJson(Map<String, dynamic> json) {
    var settings = FlashcardDeckSettings.fromJson(
      json['settings'] as Map<String, dynamic>,
    );
    // print(json['settings']);
    // print(json['settings'] as Map<String, dynamic>);

    var solutions = {
      for (var entry in (json['solutions'] as Map<String, dynamic>).entries)
        entry.key: _solutionFromJson(entry.value),
    };
    // print(json['solutions']);
    return PokerFlashcardDeck(settings: settings, solutions: solutions);
  }

  FlashcardResult verifyResponse(String hand, PokerAction? action) {
    // get the answer of current state
    // compare the input with the actual answer
    final sol = solutions[hand]!;

    // print('$hand, $sol, $percentageBB');

    if (action == null) {
      return FlashcardResult(isCorrect: false, solution: sol);
    }
    PokerAction? keyMax;
    for (var entry in sol.entries) {
      if (keyMax == null || entry.value > sol[keyMax]!) {
        keyMax = entry.key;
      }
    }
    return FlashcardResult(isCorrect: action == keyMax, solution: sol);
  }
}

class FlashcardDeckSettings {
  final PokerPosition position;
  final PokerSituation situation;
  FlashcardDeckSettings({required this.position, required this.situation});

  factory FlashcardDeckSettings.fromJson(Map<String, dynamic> json) {
    final position = PokerPositionExtension.fromString(json['position']);
    final situation = PokerSituationExtension.fromString(json['situation']);
    return FlashcardDeckSettings(position: position, situation: situation);
  }
}

// One Solution correspond to one "card"
typedef Solution = Map<PokerAction, double>;
Solution _solutionFromJson(Map<String, dynamic> d) {
  return {
    for (MapEntry<String, dynamic> entry in d.entries)
      PokerActionExtension.fromString(entry.key): double.parse(
        entry.value.toString(),
      ),
  };
}

class FlashcardResult {
  final bool isCorrect;
  final Map<PokerAction, double> solution;

  const FlashcardResult({required this.isCorrect, required this.solution});
}
