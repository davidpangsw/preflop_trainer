
import 'package:preflop_trainer/models/playing_card/hand.dart';

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
