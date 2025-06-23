import 'package:preflop_trainer/models/playing_card/hand.dart';

class PokerState {
  PokerPosition position;
  PokerSituation situation;
  Hand hand;

  PokerState({
    required this.position,
    required this.situation,
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

enum PokerAction { fold, check, call, raise }

class PokerActionExtension {
  static PokerAction fromString(String s) => switch (s) {
    "Fold" => PokerAction.fold,
    "Check" => PokerAction.check, // Similar to fold. You won't fold if you can check.
    "Call" => PokerAction.call,
    "Raise" => PokerAction.raise,
    _ => throw FormatException('Invalid action: $s'),
  };
}

enum PokerSituation { open, threebet, fourbet }
