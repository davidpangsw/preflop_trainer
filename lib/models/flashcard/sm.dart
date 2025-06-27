// This file uses SM2 algorithm

import 'dart:convert';

class Sm {
  // repeitions >= 0
  // previousInterval >= 0
  // previousEaseFactor >= 1.3
  SmResponse calc({
    required SmResponseQuality quality,
    required int repetitions,
    required int previousInterval,
    required double previousEaseFactor,
  }) {
    int interval;
    int qualityValue = quality.value;
    if (qualityValue >= 3) {
      switch (repetitions) {
        case 0:
          interval = 1;
        case 1:
          interval = 6;
        default:
          interval = (previousInterval * previousEaseFactor).round();
      }

      repetitions++;
    } else {
      repetitions = 0;
      interval = 1; // 0 or 1, depending on the app or how strict we want
    }

    // calculate ease factor
    double easeFactor =
        previousEaseFactor +
        (0.1 - (5 - qualityValue) * (0.08 + (5 - qualityValue) * 0.02));
    // Cap ease factor between 1.3 and 2.5
    if (easeFactor < 1.3) {
      easeFactor = 1.3;
    } else if (easeFactor > 2.5) {
      easeFactor = 2.5;
    }

    return SmResponse(
      interval: interval,
      repetitions: repetitions,
      easeFactor: easeFactor,
    );
  }
}

/// Response type from calc
class SmResponse {
  final int interval;
  final int repetitions;
  final double easeFactor;

  SmResponse({
    required this.interval,
    required this.repetitions,
    required this.easeFactor,
  });

  String toJson() => json.encode({
    'interval': interval,
    'repetitions': repetitions,
    'easeFactor': easeFactor,
  });

  factory SmResponse.fromJson(Map<String, dynamic> json) {
    return SmResponse(
      interval: json['interval'],
      repetitions: json['repetitions'],
      easeFactor: json['easeFactor'],
    );
  }
  factory SmResponse.fromJsonString(String s) {
    return SmResponse.fromJson(jsonDecode(s) as Map<String, dynamic>);
  }

  @override
  String toString() {
    return 'SmResponse(interval: $interval, repetitions: $repetitions, easeFactor: $easeFactor)';
  }
}

enum SmResponseQuality {
  blackout(0), // Complete blackout
  incorrectRemembered(1), // Incorrect response; correct one remembered
  incorrectEasy(2), // Incorrect response; correct one seemed easy to recall
  correctDifficult(3), // Correct response recalled with serious difficulty
  correctHesitant(4), // Correct response after hesitation
  perfect(5); // Perfect response

  final int value;

  const SmResponseQuality(this.value);
}
