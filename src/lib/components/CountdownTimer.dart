import 'dart:async';

class CountdownStopTimer {
  CountdownStopTimer(
      int period, void Function()? onPeriodic, void Function()? onEnd) {
    _remainingTime = 0;
    _period = period;
    _onPeriodic = onPeriodic;
    _onEnd = onEnd;
  }

  late Timer _timer;
  late int _remainingTime;
  late int _period;
  late void Function()? _onPeriodic;
  late void Function()? _onEnd;

  bool isRunning = false;

  int get remainingTime => _remainingTime;

  int get period => _period;

  set period(int value) {
    if (value >= _remainingTime) {
      _period = value;
    } else {
      throw FormatException('New period is smaller than remaining time');
    }
  }

  void start() {
    final timerDuration = Duration(milliseconds: 50);

    _timer = Timer.periodic(timerDuration, (timer) {
      if (_remainingTime == 0) {
        timer.cancel();

        if (_onEnd != null) {
          _onEnd!();
        }
      } else {
        _remainingTime -= timerDuration.inMilliseconds;

        if (_onPeriodic != null) {
          _onPeriodic!();
        }
      }
    });
  }

  void stop() {
    _timer.cancel();

    _remainingTime = 0;
  }

  void reset() {
    _remainingTime = _period;
  }
}
