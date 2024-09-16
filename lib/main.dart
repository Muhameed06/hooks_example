// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

enum Action { rotateLeft, rotateRight, moreVisible, lessVisible }

@immutable
class State {
  final double rotationDeg;
  final double alpha;

  const State({
    required this.rotationDeg,
    required this.alpha,
  });

  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(rotationDeg: rotationDeg + 10.0, alpha: alpha);
  State rotateLeft() => State(rotationDeg: rotationDeg - 10.0, alpha: alpha);
  State increaseAlpha() =>
      State(rotationDeg: rotationDeg, alpha: min(alpha + 0.1, 1.0));
  State decreaseAlpha() =>
      State(rotationDeg: rotationDeg, alpha: max(alpha - 0.1, 0.0));
}

const url =
    'https://media.istockphoto.com/id/1069539210/photo/fantastic-autumn-sunset-of-hintersee-lake.jpg?s=612x612&w=0&k=20&c=oqKJzUgnjNQi-nSJpAxouNli_Xl6nY7KwLBjArXr_GE=';

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(reducer,
        initialState: const State.zero(), initialAction: null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Home page',
        ),
      ),
      body: Column(children: [
        Row(
          children: [
            RotateLeftButton(store: store),
            RotateRightButton(store: store),
            IncreaseAlphaButton(store: store),
            DecreaseAlphaButton(store: store),
          ],
        ),
        const SizedBox(
          height: 100,
        ),
        Opacity(
          opacity: store.state.alpha,
          child: RotationTransition(
              turns: AlwaysStoppedAnimation(store.state.rotationDeg / 360),
              child: Image.network(url)),
        ),
      ]),
    );
  }
}

class DecreaseAlphaButton extends StatelessWidget {
  const DecreaseAlphaButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(Action.lessVisible);
        },
        child: const Text('Decrease'));
  }
}

class IncreaseAlphaButton extends StatelessWidget {
  const IncreaseAlphaButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(Action.moreVisible);
        },
        child: const Text('Increase'));
  }
}

class RotateRightButton extends StatelessWidget {
  const RotateRightButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(Action.rotateRight);
        },
        child: const Text('Rotate right'));
  }
}

class RotateLeftButton extends StatelessWidget {
  const RotateLeftButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(Action.rotateLeft);
        },
        child: const Text('Rotate left'));
  }
}

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) {
    return map(transform ?? (e) => e).where((e) => e != null).cast();
  }
}

extension Normalize on num {
  num normalized(num selfRangeMin, num selfRangeMax,
      [num normalizedRangeMin = 0.0, num normalizedRangeMax = 1.0]) {
    final normalized = (normalizedRangeMax - normalizedRangeMin) *
            ((this - selfRangeMin) / (selfRangeMax - selfRangeMin)) +
        normalizedRangeMin;
    return normalized;
  }
}
