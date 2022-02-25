import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'bubbleSort.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("BubbleSort Demo")),
        body: SizedBox.expand(
        child: Container(
          color: const Color(0xFF15202D),
          child: BubbleSortVisualizer(),
        ),
        ),
      ),
    );
  }
}

