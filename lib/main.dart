import 'dart:async';
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

const url =
    'https://media.istockphoto.com/id/1069539210/photo/fantastic-autumn-sunset-of-hintersee-lake.jpg?s=612x612&w=0&k=20&c=oqKJzUgnjNQi-nSJpAxouNli_Xl6nY7KwLBjArXr_GE=';
const imageHeight = 300.0;

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    late final StreamController<double> controller;
    controller = useStreamController<double>(
      onListen: () {
        controller.sink.add(0.0);
      }
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Home page',
        ),
      ),
      body: StreamBuilder<double>(
          stream: controller.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              final rotation = snapshot.data ?? 0.0;
              return GestureDetector(
                onTap: () {
                  controller.sink.add(rotation + 10.0);
                },
                child: RotationTransition(
                    turns: AlwaysStoppedAnimation(rotation / 360.0),
                    child: Center(child: Image.network(url))),
              );
            }
          }),
    );
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
