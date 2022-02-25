import 'dart:math';

import 'package:app_code/bubbleSort.dart';
import 'package:app_code/quickSort.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
          child: QuickSortVisualizer(),
        ),
        ),
      ),
    );
  }
}

