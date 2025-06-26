import 'package:flutter/material.dart';
import 'package:preflop_trainer/utils/action_box.dart';
import 'package:preflop_trainer/main.dart';
import 'package:preflop_trainer/models/poker/poker_flashcard_deck.dart';
import 'package:preflop_trainer/models/playing_card/card.dart' as models;
import 'package:provider/provider.dart';

class HandChart extends StatefulWidget {
  const HandChart({super.key});

  @override
  State<HandChart> createState() => _HandChartState();
}

class _HandChartState extends State<HandChart> {
  final int gridSize = 13;
  final List<models.Rank> allRanks = models
      .RankExtension
      .ranksSortedByPokerValue
      .reversed
      .toList();
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
    if (appState.pack == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Header row
        Expanded(
          child: Row(
            children: [
              // Container(width: 30), // Empty corner
              Expanded(child: Text('')), // Empty Corner
              for (var rank in allRanks)
                Expanded(
                  child: getHeaderCell(rank.toSymbol()),
                ),
            ],
          ),
        ),
        // Rows
        for (int row = 0; row < gridSize; row++)
          Expanded(
            child: Row(
              children: [
                // Row header
                Expanded(
                  child: getHeaderCell(allRanks[row].toSymbol()),
                ),
                // Cells
                for (int col = 0; col < gridSize; col++)
                  Expanded(
                    child: getCell(row, col, appState.pack!.flashcardDeck),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget getHeaderCell(String s) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          s,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Get cell content for grid position
  Widget getCell(int row, int col, PokerFlashcardDeck data) {
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

    return ActionBox(hand: hand, percentages: percentages);
  }
}
