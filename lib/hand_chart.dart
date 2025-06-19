import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preflop_trainer/models/card.dart' as models;
import 'package:preflop_trainer/utils/mixed_box.dart';

class HandChart extends StatefulWidget {
  const HandChart({super.key});

  @override
  State<HandChart> createState() => _HandChartState();
}

class _HandChartState extends State<HandChart> {
  final int gridSize = 13;
  final List<models.Rank> allRanks = models.Rank.values.reversed.toList();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadHandData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          print(snapshot.error.toString());
          return const Center(child: Text('Error loading hand data'));
        }
        // hand -> bet (in #BB) -> percentage
        final Map<String, Map<String, double>> data = snapshot.data!;

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
                      child: getCell(row, col, data),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }

  Future<Map<String, Map<String, double>>> loadHandData(
    BuildContext context,
  ) async {
    final String jsonString = await rootBundle.loadString(
      'decks/open/utg.json',
    );
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final solutions = jsonData["solutions"] as Map<String, dynamic>?;
    if (solutions == null) {
      throw FormatException('Missing or null "solutions" key in JSON');
    }
    return solutions.map((hand, solution) {
      final sol = solution as Map<String, dynamic>;
      // print(hand);
      // print(sol);
      return MapEntry(
        hand,
        sol.map((action, percentage) {
          final doubleValue = (percentage is int)
              ? percentage.toDouble()
              : percentage as double;
          return MapEntry(action, doubleValue);
        }),
      );
    });
  }

  // Get cell content for grid position
  Widget getCell(int row, int col, Map<String, Map<String, double>> data) {
    // row, col: 0 - 12
    // v1, v2: 14 - 2
    // r1, r2: A - 2
    int v1 = 14 - row; // From 14 to 2
    int v2 = 14 - col; // From 14 to 2
    String hand;
    var r1 = models.RankExtension.ofPokerValue(v1);
    var r2 = models.RankExtension.ofPokerValue(v2);
    print("Debug!! ${r1} ${r2}");
    if (row < col) {
      hand = '${r1.toSymbol()}${r2.toSymbol()}s'; // Suited
    } else if (row > col) {
      hand = '${r2.toSymbol()}${r1.toSymbol()}o'; // Off-Suited
    } else {
      hand = '${r1.toSymbol()}${r2.toSymbol()}'; // Pocket pair
    }
    print(data[hand]);
    var handData = data[hand]!;
    var actions = {"2", "0"};
    var percentages = actions.map((action) => handData[action] ?? 0).toList();

    return MixedBox(
      percentages: percentages,
      colors: [Colors.red, Colors.green],
    );
  }
}
