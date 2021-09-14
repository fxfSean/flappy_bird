
import 'dart:async';

import 'dart:math';

class ScoreCounter {
  int score = 0;
  int maxScore = 0;
  bool _isRecorded = false;
  bool get isRecorded => _isRecorded;


  void calculateMax() {
    maxScore = max(maxScore, score);
  }

  void reset() {
    score = 0;
    _isRecorded = false;
  }

  void increaseScore() {
    _isRecorded = true;
    score++;
  }

  void markUnRecorded() {
    _isRecorded = false;
  }

}

ScoreCounter scoreCounter = ScoreCounter();