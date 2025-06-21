class FlashcardDeck {
  final Map<String, dynamic> settings;
  final Map<String, Solution> solutions;

  FlashcardDeck({required this.settings, required this.solutions});

  factory FlashcardDeck.fromJson(Map<String, dynamic> json) {
    var settings = json['settings'] as Map<String, dynamic>;
    // print(json['settings']);
    // print(json['settings'] as Map<String, dynamic>);

    var solutions = {
      for (var entry in (json['solutions'] as Map<String, dynamic>).entries)
        entry.key: _solutionFromJson(entry.value),
    };
    // print(json['solutions']);
    return FlashcardDeck(settings: settings, solutions: solutions);
  }

  bool verifyResponse(String hand, int percentageBB) {
    final sol = solutions[hand]!;

    // print('$hand, $sol, $percentageBB');

    String? keyMax;
    for (var entry in sol.entries) {
      if (keyMax == null || entry.value > sol[keyMax]!) {
        keyMax = entry.key;
      }
    }
    int answer = (double.parse(keyMax!) * 100).round();
    return (answer == percentageBB);
  }
}

typedef Solution = Map<String, double>;
Solution _solutionFromJson(Map<String, dynamic> d) {
  return {
    for (var entry in d.entries)
      entry.key: double.parse(entry.value.toString()),
  };
}
