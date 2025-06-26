import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:preflop_trainer/models/flashcard/sm.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Correspond to a deck of flashcard states
class SmDeck {
  final sm = Sm();

  final String id;
  final List<String> deck;
  final Map<String, SmCardState> cardStates;
  final HeapPriorityQueue<String> reviewQueue;

  SmDeck({required this.id, required this.deck, required this.cardStates})
    : reviewQueue = HeapPriorityQueue<String>((a, b) {
        final r1 = cardStates[a]!.response;
        final r2 = cardStates[b]!.response;
        // print("Comparing: $r1, $r2");

        var diff = r1.interval.compareTo(r2.interval);
        // print("Diff: $diff");
        if (diff != 0) return diff;

        diff = r1.repetitions.compareTo(r2.repetitions);
        if (diff != 0) return diff;

        // the larger, the earlier
        return r2.easeFactor.compareTo(r1.easeFactor);
      })..addAll(deck);

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

    deck.shuffle(); // shuffle the deck to give random start

    return SmDeck(id: id, deck: deck, cardStates: cardStates);
  }

  // Peeks at the top card ID in the reviewQueue without removing it
  String? get topCard {
    if (reviewQueue.isEmpty) {
      return null; // Return null if the queue is empty
    }
    return reviewQueue.first; // Returns the top element (smallest interval)
  }

  Iterable<String> get dueCards {
    return reviewQueue.toList().where(
      (card) => !cardStates[card]!.dueDate.isAfter(DateTime.now()),
    );
  }

  DateTime? get nextDue {
    final top = topCard;
    if (top == null) return null;
    return cardStates[top]!.dueDate;
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

  String toBriefJson(int i) {
    final Map<String, dynamic> jsonMap = {
      'id': id,
      // 'deck': deck,
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
      'deck': deck,
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

  factory SmDeck.fromJson(String json) {
    final jsonMap = jsonDecode(json);
    final id = jsonMap['id'] as String;
    final deck = List<String>.from(jsonMap['deck']);
    final cardStates = {
      for (var entry in (jsonMap['cardStates'] as Map<String, dynamic>).entries)
        entry.key: SmCardState(
          response: SmResponse.fromJsonString(entry.value['response']),
          dueDate: DateTime.parse(entry.value['dueDate']),
        ),
    };
    return SmDeck(id: id, deck: deck, cardStates: cardStates);
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(id, toJson());
  }

  static Future<SmDeck?> load(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(id);
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

class SmCardState {
  static final sm = Sm();

  SmResponse response;
  DateTime dueDate;

  SmCardState({required this.response, required this.dueDate});

  // only for top card (least interval)
  void acceptResponse(SmResponseQuality quality) {
    // print(response.repetitions);
    // print(response.repetitions+1);
    response = sm.calc(
      quality: quality,
      repetitions: response.repetitions,
      previousInterval: response.interval,
      previousEaseFactor: response.easeFactor,
    );
    // print(response.repetitions);

    dueDate = dueDate.add(Duration(days: response.interval));
  }

  String toJson() {
    final Map<String, dynamic> jsonMap = {
      'response': {
        'interval': response.interval,
        'repetitions': response.repetitions,
        'easeFactor': response.easeFactor,
      },
      'dueDate': dueDate.toIso8601String(),
    };
    return jsonEncode(jsonMap);
  }

  factory SmCardState.fromJson(Map<String, dynamic> json) {
    final response = SmResponse.fromJson(
      json['response'] as Map<String, dynamic>,
    );
    final dueDate = DateTime.parse(json['dueDate']);
    return SmCardState(response: response, dueDate: dueDate);
  }

  @override
  String toString() {
    return 'SmCardState{response: $response, dueDate: $dueDate}';
  }
}
