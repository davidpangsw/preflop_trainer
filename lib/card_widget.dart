import 'package:flutter/material.dart';
import 'package:preflop_trainer/models/card.dart' as models;

class CardWidget extends StatelessWidget {
  final models.Card card;
  final double width;
  final double height;

  const CardWidget({
    super.key,
    required this.card,
    this.width = 80,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top-left rank and suit
          Positioned(
            top: 4,
            left: 4,
            child: _buildRankAndSuit(),
          ),
          // Center suit (larger)
          Center(
            child: Text(
              _suitSymbol(card.suit),
              style: TextStyle(
                fontSize: 40,
                color: _suitColor(card.suit),
              ),
            ),
          ),
          // Bottom-right rank and suit (mirrored)
          Positioned(
            bottom: 4,
            right: 4,
            child: Transform.rotate(
              angle: 3.14, // 180 degrees
              child: _buildRankAndSuit(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankAndSuit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _rankSymbol(card.rank),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _suitColor(card.suit),
          ),
        ),
        Text(
          _suitSymbol(card.suit),
          style: TextStyle(
            fontSize: 16,
            color: _suitColor(card.suit),
          ),
        ),
      ],
    );
  }

  String _rankSymbol(models.Rank rank) => switch (rank) {
        models.Rank.ace => 'A',
        models.Rank.two => '2',
        models.Rank.three => '3',
        models.Rank.four => '4',
        models.Rank.five => '5',
        models.Rank.six => '6',
        models.Rank.seven => '7',
        models.Rank.eight => '8',
        models.Rank.nine => '9',
        models.Rank.ten => '10',
        models.Rank.jack => 'J',
        models.Rank.queen => 'Q',
        models.Rank.king => 'K',
      };

  String _suitSymbol(models.Suit suit) => switch (suit) {
        models.Suit.spades => '♠',
        models.Suit.hearts => '♥',
        models.Suit.diamonds => '♦',
        models.Suit.clubs => '♣',
      };

  Color _suitColor(models.Suit suit) => switch (suit) {
        models.Suit.spades || models.Suit.clubs => Colors.black,
        models.Suit.hearts || models.Suit.diamonds => Colors.red,
      };
}