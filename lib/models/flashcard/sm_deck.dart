import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:preflop_trainer/models/flashcard/sm.dart';

class SmDeck {
  final sm = Sm();

  final String id;
  final List<String> deck;
  final Map<String, SmResponse> responses;
  final HeapPriorityQueue<String> reviewQueue;

  SmDeck({required this.id, required this.deck, required this.responses})
    : reviewQueue = HeapPriorityQueue<String>((a, b) {
        final r1 = responses[a]!;
        final r2 = responses[b]!;
        final diff = r1.interval.compareTo(r2.interval);
        if (diff == 0) {
          return r1.repetitions.compareTo(r2.repetitions);
        }
        return diff;
      })..addAll(deck);

  factory SmDeck.withDefaultResponses({
    required id,
    required List<String> deck,
  }) {
    final responses = {
      for (var key in deck)
        key: SmResponse(interval: 0, repetitions: 0, easeFactor: 2.5),
    };
    return SmDeck(id: id, deck: deck, responses: responses);
  }

  // Peeks at the top card ID in the reviewQueue without removing it
  String? get topCard {
    if (reviewQueue.isEmpty) {
      return null; // Return null if the queue is empty
    }
    return reviewQueue.first; // Returns the top element (smallest interval)
  }

  // only for top card (least interval)
  SmResponse acceptResponse(SmResponseQuality quality) {
    final cardId = reviewQueue.removeFirst();
    final state = responses[cardId]!;
    responses[cardId] = sm.calc(
      quality: quality,
      repetitions: state.repetitions + 1,
      previousInterval: state.interval,
      previousEaseFactor: state.easeFactor,
    );
    reviewQueue.add(cardId);
    return responses[cardId]!;
  }

  List<String> top(int size) {
    return reviewQueue.toList().sublist(0, size);
  }

  List<MapEntry<String, SmResponse>> topEntries(int size) {
    return [for (var key in top(size)) MapEntry(key, responses[key]!)];
  }

  String toJson() {
    final Map<String, dynamic> jsonMap = {
      'id': id,
      'deck': deck,
      'responses': {
        for (var entry in responses.entries)
          entry.key: {
            'interval': entry.value.interval,
            'repetitions': entry.value.repetitions,
            'easeFactor': entry.value.easeFactor,
          },
      },
    };
    return jsonEncode(jsonMap);
  }

  factory SmDeck.fromJson(String json) {
    final jsonMap = jsonDecode(json);
    final id = jsonMap['id'] as String;
    final deck = List<String>.from(jsonMap['deck']);
    final responses = {
      for (var entry in (jsonMap['responses'] as Map<String, dynamic>).entries)
        entry.key: SmResponse(
          interval: entry.value['interval'],
          repetitions: entry.value['repetitions'],
          easeFactor: entry.value['easeFactor'],
        ),
    };
    return SmDeck(id: id, deck: deck, responses: responses);
  }
}
