
import 'dart:convert';

import 'package:preflop_trainer/models/flashcard/sm.dart';

class SmCardState {
  static final sm = Sm();

  SmResponse response;
  DateTime dueDate;

  SmCardState({required this.response, required this.dueDate});

  // only for top card (least interval)
  void acceptResponse(SmResponseQuality quality) {
    response = sm.calc(
      quality: quality,
      repetitions: response.repetitions,
      previousInterval: response.interval,
      previousEaseFactor: response.easeFactor,
    );
    dueDate = DateTime.now().add(Duration(days: response.interval));
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
