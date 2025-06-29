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
    return FlashcardResult.verify(hand: hand, sol: sol, action: action);
  }
}

class FlashcardDeckSettings {
  final PokerPosition position;
  final PokerSituation situation;
  FlashcardDeckSettings({required this.position, required this.situation});

  factory FlashcardDeckSettings.fromJson(Map<String, dynamic> json) {
    final position = PokerPosition.fromString(json['position']);
    final situation = PokerSituation.fromString(json['situation']);
    return FlashcardDeckSettings(position: position, situation: situation);
  }
}

// One Solution correspond to one "card"
typedef Solution = Map<PokerAction, double>;
// caller should ensure all the values are proper double within [0, 1]
// and their sum is in [0, 1]
Solution _solutionFromJson(Map<String, dynamic> d) {
  var ret = <PokerAction, double>{};
  double total = 100.0;
  for (MapEntry<String, dynamic> entry in d.entries) {
    PokerAction action = PokerAction.fromString(entry.key);
    if (action == PokerAction.fold) continue;
    double p = double.parse(entry.value.toString());
    total = total - p;
    ret[action] = p;
  }
  ret[PokerAction.fold] = total;
  // print(d);
  // print(ret);

  return ret;
}

class FlashcardResult {
  final String hand;
  final Map<PokerAction, double> solution;
  final PokerAction? action;
  final bool isCorrect;

  const FlashcardResult({
    required this.hand,
    required this.solution,
    required this.action,
    required this.isCorrect,
  });

  factory FlashcardResult.verify({
    required hand,
    required sol,
    required action,
  }) {
    // print('$hand, $sol, $percentageBB');

    bool isCorrect;
    if (action == null) {
      isCorrect = false;
    } else {
      double p = sol[action] ?? 0;
      isCorrect = true;
      for (var entry in sol.entries) {
        if (p < entry.value) {
          isCorrect = false;
          break;
        }
      }
    }

    return FlashcardResult(
      hand: hand,
      solution: sol,
      action: action,
      isCorrect: isCorrect,
    );
  }
}
