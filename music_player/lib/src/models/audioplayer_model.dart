import 'package:flutter/material.dart';

class AudioPlayerModel with ChangeNotifier {
  bool _playing = false;

  Duration _songDuration = new Duration(milliseconds: 0);
  Duration _current = new Duration(milliseconds: 0);

  String get songTotalDuration => this.printDuration(_songDuration);
  String get currentSecond => this.printDuration(_current);

  double get porcent => (this._songDuration.inSeconds > 0)
      ? this._current.inSeconds / this._songDuration.inSeconds
      : 0;

  AnimationController? _controller;
  AnimationController get controller => this.controller;
  bool get playing => this._playing;
  Duration get songDuration => this._songDuration;
  Duration get current => this._current;

  set controller(AnimationController vaule) {
    this._controller = vaule;
  }

  set playing(bool vaule) {
    this._playing = vaule;
    notifyListeners();
  }

  set songDuration(Duration vaule) {
    this._songDuration = vaule;
    notifyListeners();
  }

  set current(Duration vaule) {
    this._current = vaule;
    notifyListeners();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
