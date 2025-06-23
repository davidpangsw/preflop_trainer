
import 'package:flutter/material.dart';
import 'package:preflop_trainer/action_box.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/models/flashcard/flashcard_deck.dart';
import 'package:preflop_trainer/models/playing_card/card.dart' as models;
import 'package:provider/provider.dart';

class HandChart extends StatefulWidget {
  const HandChart({super.key});

  @override
  State<HandChart> createState() => _HandChartState();
}

class _HandChartState extends State<HandChart> {
  final int gridSize = 13;
  final List<models.Rank> allRanks = models.RankExtension.ranksSortedByPokerValue.reversed.toList();
  @override
  Widget build(BuildContext context) {
    // if (snapshot.connectionState == ConnectionState.waiting) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    // if (snapshot.hasError || !snapshot.hasData) {
    //   return Center(child: Text('Error loading hand data: ${snapshot.error}'));
    // }
    // // hand -> bet (in #BB) -> percentage
    // final FlashcardDeck data = snapshot.data!;

    var appState = context.watch<MyAppState>();
    final FlashcardDeck? data = appState.flashcardDeck;

    if (appState.flashcardDeck == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Header row
        Row(
          children: [
            Container(width: 30), // Empty corner
            for (var rank in allRanks)
              Container(
                width: 40,
                height: 30,
                alignment: Alignment.center,
                child: Text(
                  rank.toSymbol(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        // Grid
        for (int row = 0; row < gridSize; row++)
          Row(
            children: [
              // Row label
              Container(
                width: 30,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  allRanks[row].toSymbol(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Cells
              for (int col = 0; col < gridSize; col++)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: getCell(row, col, data!),
                ),
            ],
          ),
      ],
    );
  }

  // Get cell content for grid position
  Widget getCell(int row, int col, FlashcardDeck data) {
    // row, col: 0 - 12
    // v1, v2: 14 - 2
    // r1, r2: A - 2
    int v1 = 14 - row; // From 14 to 2
    int v2 = 14 - col; // From 14 to 2
    String hand;
    var r1 = models.RankExtension.ofPokerValue(v1);
    var r2 = models.RankExtension.ofPokerValue(v2);
    // print("Debug!! ${r1} ${r2}");
    if (row < col) {
      hand = '${r1.toSymbol()}${r2.toSymbol()}s'; // Suited
    } else if (row > col) {
      hand = '${r2.toSymbol()}${r1.toSymbol()}o'; // Off-Suited
    } else {
      hand = '${r1.toSymbol()}${r2.toSymbol()}'; // Pocket pair
    }
    // print(data[hand]);
    var percentages = data.solutions[hand]!;

    return ActionBox(
      percentages: percentages
    );
  }
}
