import 'dart:ui';

import 'package:flutter/material.dart';
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
  bb;

  factory PokerPosition.fromString(String s) => switch (s) {
    "utg" => PokerPosition.utg,
    "utg1" => PokerPosition.utg1,
    "utg2" => PokerPosition.utg2,
    "lj" => PokerPosition.lj,
    "hj" => PokerPosition.hj,
    "co" => PokerPosition.co,
    "btn" => PokerPosition.btn,
    "sb" => PokerPosition.sb,
    "bb" => PokerPosition.bb,
    _ => throw FormatException('Invalid position: $s'),
  };
}

enum PokerAction {
  fold,
  check,
  call,
  raise;

  Color get color {
    return switch (this) {
      PokerAction.fold || PokerAction.check => Colors.blue,
      PokerAction.call => Colors.green,
      PokerAction.raise => Colors.red,
    };
  }

  String get displayName {
    return switch (this) {
      PokerAction.fold => 'Fold',
      PokerAction.check => 'Check',
      PokerAction.call => 'Call',
      PokerAction.raise => 'Raise',
    };
  }

  factory PokerAction.fromString(String s) => switch (s) {
    "fold" => PokerAction.fold,
    "check" =>
      PokerAction.check, // Similar to fold. You won't fold if you can check.
    "call" => PokerAction.call,
    "raise" => PokerAction.raise,
    _ => throw FormatException('Invalid action: $s'),
  };
}

enum PokerSituation {
  open,
  threebet,
  fourbet;

  factory PokerSituation.fromString(String s) => switch (s) {
    "open" => PokerSituation.open,
    "threebet" => PokerSituation.threebet,
    "fourbet" => PokerSituation.fourbet,
    _ => throw FormatException('Invalid situation: $s'),
  };
}
