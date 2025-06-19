import 'dart:math';

enum Suit { clubs, diamonds, hearts, spades }

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

// A playing card with a [suit] and [rank]. All cards are singletons, so
/// cards with the same suit and rank are identical.
class Card {
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

    final rank = _parseRank(input[0]);
    final suit = _parseSuit(input[1]);

    return of(rank, suit);
  }

  static Rank _parseRank(String char) {
    switch (char) {
      case 'A':
        return Rank.ace;
      case '2':
        return Rank.two;
      case '3':
        return Rank.three;
      case '4':
        return Rank.four;
      case '5':
        return Rank.five;
      case '6':
        return Rank.six;
      case '7':
        return Rank.seven;
      case '8':
        return Rank.eight;
      case '9':
        return Rank.nine;
      case 'T':
        return Rank.ten;
      case 'J':
        return Rank.jack;
      case 'Q':
        return Rank.queen;
      case 'K':
        return Rank.king;
      default:
        throw FormatException('Invalid rank: $char');
    }
  }

  static Suit _parseSuit(String char) {
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

  // @override
  // bool operator ==(Object other) =>
  //     other is Card && other.suit == suit && other.rank == rank;
  // @override
  // int get hashCode => suit.hashCode ^ rank.hashCode;

  // Assume Cards are all singletons (i.e., no two cards have the same suit and rank)
  @override
  bool operator ==(Object other) => identical(this, other);
  @override
  int get hashCode => Object.hash(suit, rank);
}
