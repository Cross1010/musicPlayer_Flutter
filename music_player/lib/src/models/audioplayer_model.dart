import 'package:flutter/material.dart';

class AudioPlayerModel with ChangeNotifier {
  bool _playing = false;

  AnimationController? _controller;

  set controller(AnimationController vaule) {
    this._controller = vaule;
  }

  AnimationController get controller => this.controller;
}
