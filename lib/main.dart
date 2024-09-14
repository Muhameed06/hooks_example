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

const url = 'https://media.istockphoto.com/id/1069539210/photo/fantastic-autumn-sunset-of-hintersee-lake.jpg?s=612x612&w=0&k=20&c=oqKJzUgnjNQi-nSJpAxouNli_Xl6nY7KwLBjArXr_GE=';
const imageHeight = 300.0;

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final opacity = useAnimationController(
        duration: const Duration(seconds: 1),
        initialValue: 1.0,
        lowerBound: 0.0,
        upperBound: 1.0);

    final size = useAnimationController(
        duration: const Duration(seconds: 1),
        initialValue: 1.0,
        lowerBound: 0.0,
        upperBound: 1.0);

    final scrollController = useScrollController();

    useEffect(() {
      scrollController.addListener(() {
        final newOpacity = max(imageHeight - scrollController.offset, 0);
        final normalized = newOpacity.normalized(0.0, imageHeight).toDouble();
        opacity.value = normalized;
        size.value = normalized;
      });

      return null;
    }, [scrollController]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Home page',
        ),
      ),

      body: Column(
        children: [
          SizeTransition(
            sizeFactor: size,
            axis: Axis.vertical,
            axisAlignment: -1.0,
            child: FadeTransition(
              opacity: opacity,
              child: Image.network(
                url,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(controller: scrollController, itemCount: 100, itemBuilder: (context, index) { 
              return ListTile(
                title: Text('Person ${index + 1}',),
              );
            }),
          )
        ],

      ),
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
