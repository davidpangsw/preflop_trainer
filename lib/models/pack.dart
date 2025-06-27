import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:preflop_trainer/models/flashcard/sm.dart';
import 'package:preflop_trainer/models/flashcard/sm_deck.dart';
import 'package:preflop_trainer/models/playing_card/hand.dart';
import 'package:preflop_trainer/models/poker/poker_flashcard_deck.dart';
import 'package:preflop_trainer/models/poker/poker_state.dart';

// Correspond to a complete pair of (PokerFlashcardDeck, SmDeck)
class Pack {
  final String id;

  // Store the solutions under different poker game states
  final PokerFlashcardDeck _flashcardDeck;
  PokerFlashcardDeck get flashcardDeck => _flashcardDeck;

  // Manage a String -> SmCardState Mapping
  // Store the Sm state of each card, and a review queue.
  // No knowledge about the poker
  SmDeck _smDeck;

  Pack({
    required this.id,
    required PokerFlashcardDeck flashcardDeck,
    required SmDeck smDeck,
  }) : _flashcardDeck = flashcardDeck,
       _smDeck = smDeck;

  Iterable<String> get dueCards => _smDeck.dueCards;

  DateTime? get nextDue => _smDeck.nextDue;

  void reduceDue(Duration duration) {
    _smDeck.reduceDue(duration);
    _smDeck.save();
  }

  PokerState? nextQuestion() {
    // take another card
    final newItem = _smDeck.topCard;
    if (newItem == null) return null;
    final newHand = Hand.randomFromPreflopSymbol(newItem);

    final pokerState = PokerState(
      position: _flashcardDeck.settings.position,
      situation: _flashcardDeck.settings.situation,
      hand: newHand,
    );
    return pokerState;
  }

  // only top card could accept response
  FlashcardResult acceptResponse(PokerAction? action) {
    final card = _smDeck.topCard!;
    final result = _flashcardDeck.verifyResponse(card, action);
    _smDeck.acceptResponse(
      result.isCorrect ? SmResponseQuality.perfect : SmResponseQuality.blackout,
    );
    _smDeck.save();
    return result;
  }

  Future<void> resetMemory() async {
    _smDeck.resetStates();
    await _smDeck.save();
  }

  static Future<Pack> load(AssetBundle bundle, String packId) async {
    // load decks/deckId
    // load from decks/$deckId.json
    final Map<String, dynamic> jsonData = await bundle.loadStructuredData(
      'decks/$packId.json',
      (value) async {
        return json.decode(value);
      },
    );
    final deck = PokerFlashcardDeck.fromJson(jsonData);
    final smId = packId;
    final smDeck = await SmDeck.loadOrNew(smId, deck.solutions.keys.toList());

    // load from decks/deckId/**

    // combine all cards

    // await Future.delayed(const Duration(seconds: 10));
    // print("flashcard deck loaded");

    final pack = Pack(id: packId, flashcardDeck: deck, smDeck: smDeck);
    return pack;
  }

  String toBriefJson() {
    return _smDeck.toBriefJson(5);
  }
}
