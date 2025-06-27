import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:preflop_trainer/models/flashcard/sm.dart';
import 'package:preflop_trainer/models/flashcard/sm_card_state.dart';
import 'package:preflop_trainer/utils/io.dart';

// Correspond to a deck of flashcard states
class SmDeck {
  static final sm = Sm();

  final String id;
  Iterable<String> get deck => cardStates.keys;
  final Map<String, SmCardState> cardStates;
  final HeapPriorityQueue<String>
  reviewQueue; // WARNING: top card may not be of earliest due date

  SmDeck({required this.id, required this.cardStates})
    : reviewQueue = HeapPriorityQueue<String>((a, b) {
        final c1 = cardStates[a]!;
        final c2 = cardStates[b]!;
        // print("Comparing: $r1, $r2");

        final d1 = c1.dueDate;
        final d2 = c2.dueDate;
        final diffDays = d1.difference(d2).inDays;
        // print("Diff in days: $diffDays");
        if (diffDays.abs() >= 1) return diffDays;

        final r1 = c1.response;
        final r2 = c2.response;
        final diff = r1.repetitions.compareTo(r2.repetitions);
        if (diff != 0) return diff;

        // the larger, the earlier
        return r2.easeFactor.compareTo(r1.easeFactor);
      })..addAll(cardStates.keys.shuffled());

  factory SmDeck.withDefaultCardStates({
    required id,
    required List<String> deck,
  }) {
    final cardStates = {
      for (var key in deck)
        key: SmCardState(
          response: SmResponse(interval: 0, repetitions: 0, easeFactor: 2.5),
          dueDate: DateTime.now(),
        ),
    };

    return SmDeck(id: id, cardStates: cardStates);
  }

  String? get topCard {
    if (reviewQueue.isEmpty) {
      return null; // Return null if the queue is empty
    }
    return reviewQueue.first;
  }

  Iterable<String> get dueCards {
    return deck.where(
      (card) => !(cardStates[card]!.dueDate.isAfter(DateTime.now())),
    );
  }

  DateTime? get nextDue {
    if (cardStates.isEmpty) return null;
    return cardStates.values
        .reduce(
          (accum, x) => accum.dueDate.compareTo(x.dueDate) < 0 ? accum : x,
        )
        .dueDate;
  }

  // only for top card (least interval)
  void acceptResponse(SmResponseQuality quality) {
    final cardId = reviewQueue.removeFirst();
    cardStates[cardId]!.acceptResponse(quality);
    reviewQueue.add(cardId);
  }

  void reduceDue(Duration duration) {
    for (var entry in cardStates.entries) {
      entry.value.dueDate = entry.value.dueDate.subtract(duration);
    }
  }

  void resetStates() {
    for (var key in cardStates.keys) {
      cardStates[key] = SmCardState(
        response: SmResponse(interval: 0, repetitions: 0, easeFactor: 2.5),
        dueDate: DateTime.now(),
      );
    }

    // reset reviewQueue
    reviewQueue.clear();
    reviewQueue.addAll(cardStates.keys.shuffled());
  }

  String toBriefJson(int i) {
    final Map<String, dynamic> jsonMap = {
      'id': id,
      'cardStates': {
        for (var entry in cardStates.entries.toList().sublist(0, i))
          entry.key: {
            'response': entry.value.response.toJson(),
            'dueDate': entry.value.dueDate.toIso8601String(),
          },
      },
    };
    return jsonEncode(jsonMap);
  }

  String toJson() {
    final Map<String, dynamic> jsonMap = {
      'id': id,
      'cardStates': {
        for (var entry in cardStates.entries)
          entry.key: {
            'response': entry.value.response.toJson(),
            'dueDate': entry.value.dueDate.toIso8601String(),
          },
      },
    };
    return jsonEncode(jsonMap);
  }

  factory SmDeck.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    // final deck = List<String>.from(jsonMap['deck']);
    final cardStates = {
      for (var entry in (json['cardStates'] as Map<String, dynamic>).entries)
        entry.key: SmCardState(
          response: SmResponse.fromJsonString(entry.value['response']),
          dueDate: DateTime.parse(entry.value['dueDate']),
        ),
    };
    return SmDeck(id: id, cardStates: cardStates);
  }

  Future<void> save() async {
    await MyIO.save(id, toJson());
  }

  static Future<SmDeck?> load(String id) async {
    final json = await MyIO.loadJson(id);
    if (json == null) return null;
    return SmDeck.fromJson(json);
  }

  static Future<SmDeck> loadOrNew(String id, List<String> deck) async {
    var smDeck = await SmDeck.load(id);
    if (smDeck == null) {
      smDeck = SmDeck.withDefaultCardStates(id: id, deck: deck);
      await smDeck.save();
    }
    return smDeck;
  }
}
