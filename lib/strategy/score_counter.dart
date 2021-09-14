
import 'dart:async';

import 'dart:math';

class ScoreCounter {
  int score = 0;
  int maxScore = 0;
  StreamController<bool> isRecordedController = StreamController<bool>.broadcast();

  void init() {
    isRecordedController.stream.listen((event) {
      if (event) {
        score++;
      }
    });
  }

  void calculateMax() {
    maxScore = max(maxScore, score);
  }

  void reset() {
    score = 0;
  }

}

ScoreCounter scoreCounter = ScoreCounter()..init();