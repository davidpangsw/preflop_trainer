import 'dart:math';

import 'package:flutter/material.dart';

enum Suit { clubs, diamonds, hearts, spades }

extension SuitExtension on Suit {
  int toPokerValue() => switch (this) {
    Suit.clubs => 1,
    Suit.diamonds => 2,
    Suit.hearts => 3,
    Suit.spades => 4,
  };

  String toSymbol() => switch (this) {
    Suit.clubs => 'c',
    Suit.diamonds => 'd',
    Suit.hearts => 'h',
    Suit.spades => 's',
  };

  String toDisplaySymbol() => switch (this) {
    Suit.clubs => '♣',
    Suit.diamonds => '♦',
    Suit.hearts => '♥',
    Suit.spades => '♠',
  };

  Color toDisplayColor() => switch (this) {
    Suit.clubs || Suit.spades => Colors.black,
    Suit.diamonds || Suit.hearts => Colors.red,
  };
}

enum Rank {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
}

extension RankExtension on Rank {
  String toSymbol() => switch (this) {
    Rank.ace => 'A',
    Rank.two => '2',
    Rank.three => '3',
    Rank.four => '4',
    Rank.five => '5',
    Rank.six => '6',
    Rank.seven => '7',
    Rank.eight => '8',
    Rank.nine => '9',
    Rank.ten => 'T',
    Rank.jack => 'J',
    Rank.queen => 'Q',
    Rank.king => 'K',
  };

  int toPokerValue() => switch (this) {
    Rank.ace => 14,
    Rank.two => 2,
    Rank.three => 3,
    Rank.four => 4,
    Rank.five => 5,
    Rank.six => 6,
    Rank.seven => 7,
    Rank.eight => 8,
    Rank.nine => 9,
    Rank.ten => 10,
    Rank.jack => 11,
    Rank.queen => 12,
    Rank.king => 13,
  };

  String toDisplaySymbol() => switch (this) {
    Rank.ace => 'A',
    Rank.two => '2',
    Rank.three => '3',
    Rank.four => '4',
    Rank.five => '5',
    Rank.six => '6',
    Rank.seven => '7',
    Rank.eight => '8',
    Rank.nine => '9',
    Rank.ten => '10',
    Rank.jack => 'J',
    Rank.queen => 'Q',
    Rank.king => 'K',
  };

  static Rank ofSymbol(String symbol) => switch (symbol) {
    'A' => Rank.ace,
    '2' => Rank.two,
    '3' => Rank.three,
    '4' => Rank.four,
    '5' => Rank.five,
    '6' => Rank.six,
    '7' => Rank.seven,
    '8' => Rank.eight,
    '9' => Rank.nine,
    'T' => Rank.ten,
    'J' => Rank.jack,
    'Q' => Rank.queen,
    'K' => Rank.king,
    _ => throw FormatException('Invalid rank: $symbol'),
  };

  static Rank ofPokerValue(int i) => switch (i) {
    14 => Rank.ace,
    2 => Rank.two,
    3 => Rank.three,
    4 => Rank.four,
    5 => Rank.five,
    6 => Rank.six,
    7 => Rank.seven,
    8 => Rank.eight,
    9 => Rank.nine,
    10 => Rank.ten,
    11 => Rank.jack,
    12 => Rank.queen,
    13 => Rank.king,
    _ => throw FormatException('Invalid poker value: $i'),
  };
}

// A playing card with a [suit] and [rank]. All cards are singletons, so
/// cards with the same suit and rank are identical.
class Card implements Comparable<Card> {
  final Suit suit;
  final Rank rank;

  // Private Constructor
  const Card._({required this.suit, required this.rank});

  static final Map<Rank, Map<Suit, Card>> _cards = {
    for (var rank in Rank.values)
      rank: {
        for (var suit in Suit.values) suit: Card._(suit: suit, rank: rank),
      },
  };

  // Get card by rank and suit
  static Card of(Rank rank, Suit suit) => _cards[rank]![suit]!;

  // List of all cards for deck creation
  static final List<Card> all = [
    for (var rank in Rank.values)
      for (var suit in Suit.values) _cards[rank]![suit]!,
  ];

  static List<Card> random(int n) {
    if (n < 0 || n > all.length) {
      throw ArgumentError.value(
        n,
        'n',
        'Number of cards to draw must be between 0 and ${all.length}',
      );
    }

    final random = Random();
    final deck = all.toList()..shuffle(random);
    return deck.sublist(0, n);
  }

  /// Parses a string to a card, e.g., 'As' for Ace of Spades, 'Td' for Ten of Diamonds, '2h' for Two of Hearts.
  /// Format: Rank (A, 2-9, T, J, Q, K) followed by Suit (s, d, h, c).
  /// Case-sensitive. Throws [FormatException] for invalid input.
  static Card parse(String input) {
    if (input.length != 2) {
      throw FormatException(
        'Invalid card format: expected 2 chars, got "$input"',
      );
    }

    final rank = RankExtension.ofSymbol(input[0]);
    final suit = parseSuit(input[1]);

    return of(rank, suit);
  }

  static Suit parseSuit(String char) {
    switch (char) {
      case 's':
        return Suit.spades;
      case 'd':
        return Suit.diamonds;
      case 'h':
        return Suit.hearts;
      case 'c':
        return Suit.clubs;
      default:
        throw FormatException('Invalid suit: $char');
    }
  }

  @override
  String toString() {
    return '${rank.name} of ${suit.name}';
  }

  String toSymbol() {
    return '${rank.toSymbol()}${suit.toSymbol()}';
  }

  // @override
  // bool operator ==(Object other) =>
  //     other is Card && other.suit == suit && other.rank == rank;
  // @override
  // int get hashCode => suit.hashCode ^ rank.hashCode;

  // Assume Cards are all singletons (i.e., no two cards have the same suit and rank)
  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int compareTo(Card other) {
    // print('Comparing ${this} to ${other}...');
    var result = rank.toPokerValue().compareTo(other.rank.toPokerValue());
    if (result != 0) {
      return result;
    }

    return suit.toPokerValue().compareTo(other.suit.toPokerValue());
  }

  @override
  int get hashCode => Object.hash(suit, rank);
}
