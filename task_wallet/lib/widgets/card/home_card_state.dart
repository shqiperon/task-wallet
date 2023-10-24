import 'package:flutter/material.dart';

class HomeCardState implements BaseWidgetState {
  const HomeCardState(
      {required this.screen,
      required this.imageUrl,
      required this.buttonLabel});
  final Widget screen;
  final String imageUrl;
  final String buttonLabel;
}

class SpaceWidgetState implements BaseWidgetState {
  const SpaceWidgetState({required this.height});
  final double height;
}

abstract class BaseWidgetState {}
