import 'package:preflop_trainer/models/card.dart';

class Hand {
  final Card card1;
  final Card card2;

  Hand(Card c1, Card c2)
      : assert(c1 != c2, 'A hand cannot contain two identical cards.'),
        card1 = c1.compareTo(c2) < 0 ? c1 : c2, // Assigns the 'smaller' card
        card2 = c1.compareTo(c2) < 0 ? c2 : c1; // Assigns the 'larger' card

  @override
  String toString() => '[$card1, $card2]';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hand && card1 == other.card1 && card2 == other.card2);

  @override
  int get hashCode => Object.hash(card1, card2);

  bool get isSuited => card1.suit == card2.suit;
  bool get isPair => card1.rank == card2.rank;
  
  /// Generates all 1326 possible two-card starting hands.
  /// Each hand is unique based on the specific cards (e.g., [As, Kd] is distinct).
  ///
  /// Returns a [Set<Hand>] to guarantee uniqueness, as the Hand class's
  /// equality operator and hash code ensure that hands like [Ac, Kd] and [Kd, Ac]
  /// resolve to the same Hand object.
  static Set<Hand> getAllPossibleHands() {
    final allCards = Card.all;
    final Set<Hand> allHands = {};
    // Iterate through all combinations of two distinct cards
    for (int i = 0; i < allCards.length; i++) {
      for (int j = i + 1; j < allCards.length; j++) {
        allHands.add(Hand(allCards[i], allCards[j]));
      }
    }
    return allHands;
  }
}
