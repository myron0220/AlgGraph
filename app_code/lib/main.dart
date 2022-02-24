import 'dart:math';

import 'package:flutter/material.dart';

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

class BubbleSortVisualizer extends StatefulWidget {
  @override
  _BubbleSortVisualizerState createState() => _BubbleSortVisualizerState();
}

class _BubbleSortVisualizerState extends State<BubbleSortVisualizer>
    with SingleTickerProviderStateMixin {
  late List<int> _arr;
  late List<double> _widgetHeight;
  late List<int> _indToKeyNum;
  late List<Widget> _children;
  late List<double> _curPosition;

  late List<Key> _keys;

  late AnimationController _controller;
  late List<Animation<Offset>> _offsetAnimation;

  Color _boxColor = Colors.orangeAccent;
  Color _swapColor = Colors.lightBlue;
  Color _notSwapColor = Colors.deepOrange;
  Color _doneColor = Colors.lightGreen;
  double _boxWidth = 25;
  double _boxMargin = 10;

  // inplace bubble sort
  void _bubbleSort() async {
    // if current animating, do nothing,
    if (_controller.isAnimating) return;

    int n = _arr.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        await Future.delayed(Duration(seconds: 1));
        if (_arr[j] > _arr[j + 1]) {
          // animate
          _beforeAnimateSwap(j, j + 1);

          // also update the _indToKeyNum
          setState(() {
            int temp2 = _indToKeyNum[j];
            _indToKeyNum[j] = _indToKeyNum[j + 1];
            _indToKeyNum[j + 1] = temp2;
          });

          // swap arr[j+1] and arr[j]
          setState(() {
            int temp = _arr[j];
            _arr[j] = _arr[j + 1];
            _arr[j + 1] = temp;
          });
        } else {
          _notSwapAnimation(j, j + 1);
        }

        await Future.delayed(Duration(seconds: 1));
        _afterAnimateSwap(j, j + 1);
      }
      await Future.delayed(Duration(seconds: 1));
      _doneColorAnimation(n - i - 1);
    }
    await Future.delayed(Duration(seconds: 1));
    _doneColorAnimation(0);
  }

  void _doneColorAnimation(int i) {
    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _doneColor,
            position: Tween<Offset>(
              begin: Offset(_curPosition[_indToKeyNum[i]], 0.0),
              end: Offset(_curPosition[_indToKeyNum[i]], 0.0),
            ).animate(_controller),
            height: _widgetHeight[_indToKeyNum[i]],
            width: _boxWidth,
            margin: _boxMargin,
          );
    });
  }

  void _notSwapAnimation(int i, int j) {
    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _notSwapColor,
            position: Tween<Offset>(
              begin: Offset(_curPosition[_indToKeyNum[i]], 0.0),
              end: Offset(_curPosition[_indToKeyNum[i]], 0.0),
            ).animate(_controller),
            height: _widgetHeight[_indToKeyNum[i]],
            width: _boxWidth,
            margin: _boxMargin,
          );

      _children[_indToKeyNum[j]] =
          BoxWidget(
            key: _keys[_indToKeyNum[j]],
            color: _notSwapColor,
            position: Tween<Offset>(
              begin: Offset(_curPosition[_indToKeyNum[j]], 0.0),
              end: Offset(_curPosition[_indToKeyNum[j]], 0.0),
            ).animate(_controller),
            height: _widgetHeight[_indToKeyNum[j]],
            width: _boxWidth,
            margin: _boxMargin,
          );
    });
  }

  void _childrenUpdateHelper() {
    _children = [];
    for (int i = 0; i < _arr.length; i++) {
      Key curKey = UniqueKey();
      _keys.add(curKey);
      _children.add(
        BoxWidget(
          key: curKey,
          color: _boxColor,
          position: _offsetAnimation[i],
          height: _widgetHeight[i],
          width: _boxWidth,
          margin: _boxMargin,
        ),
      );
    }
  }
  
  void _beforeSwapTwoWidgetByIndex(int i, int j) {
    // print("current index: " + i.toString() + " ," + j.toString());
    // print("current keyNum: " + _indToKeyNum[i].toString() + " ," + _indToKeyNum[j].toString());

    double distanceForI = (j - i).toDouble();

    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _swapColor,
            position: Tween<Offset>(
              begin: Offset(_curPosition[_indToKeyNum[i]], 0.0),
              end: Offset(_curPosition[_indToKeyNum[i]] + distanceForI, 0.0),
            ).animate(_controller),
            height: _widgetHeight[_indToKeyNum[i]],
            width: _boxWidth,
            margin: _boxMargin,
          );

      _curPosition[_indToKeyNum[i]] += distanceForI;

      _children[_indToKeyNum[j]] =
          BoxWidget(
            key: _keys[_indToKeyNum[j]],
            color: _swapColor,
            position: Tween<Offset>(
              begin: Offset(_curPosition[_indToKeyNum[j]], 0.0),
              end: Offset(_curPosition[_indToKeyNum[j]] - distanceForI, 0.0),
            ).animate(_controller),
            height: _widgetHeight[_indToKeyNum[j]],
            width: _boxWidth,
            margin: _boxMargin,
          );

      _curPosition[_indToKeyNum[j]] -= distanceForI;

    });
  }

  void _afterSwapTwoWidgetByIndex(int i, int j) {
    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _boxColor,
            position: Tween<Offset>(
              begin: Offset(_curPosition[_indToKeyNum[i]], 0.0),
              end: Offset(_curPosition[_indToKeyNum[i]], 0.0),
            ).animate(_controller),
            height: _widgetHeight[_indToKeyNum[i]],
            width: _boxWidth,
            margin: _boxMargin,
          );

      _children[_indToKeyNum[j]] =
          BoxWidget(
            key: _keys[_indToKeyNum[j]],
            color: _boxColor,
            position: Tween<Offset>(
              begin: Offset(_curPosition[_indToKeyNum[j]], 0.0),
              end: Offset(_curPosition[_indToKeyNum[j]], 0.0),
            ).animate(_controller),
            height: _widgetHeight[_indToKeyNum[j]],
            width: _boxWidth,
            margin: _boxMargin,
          );
    });
  }

  void _beforeAnimateSwap(int i, int j) {
    _beforeSwapTwoWidgetByIndex(i, j);
    _controller.forward(from: 0.0);
  }

  void _afterAnimateSwap(int i, int j) {
    _afterSwapTwoWidgetByIndex(i, j);
  }

  // void _swapTest() {
  //   int i = 5; int j = 2;
  //   _beforeSwapTwoWidgetByIndex(i, j);
  //   _controller.forward();
  // }

  List<int> _generateRandomList(int n, int upper) {
    List<int> arr = [];
    var random = Random();
    for (int i = 0; i < n; i++) {
      arr.add(1 + random.nextInt(upper + 1));
    }
    return arr;
  }

  void _initStatesByArr(List<int> arr) {
    setState(() {
      _arr = arr;
      _widgetHeight = [];
      for (int i = 0; i < _arr.length; i++) {
        _widgetHeight.add(_arr[i] * 2);
      }
      _controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
      // used to swap two element
      _offsetAnimation = List.generate(
        _arr.length,
            (index) => Tween<Offset>(
          begin: const Offset(0.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(_controller),
      );
      // update the children;
      _keys = [];
      _indToKeyNum = [];
      for (int i = 0; i < _arr.length; i++) {
        _indToKeyNum.add(i);
      }
      _childrenUpdateHelper();
      _curPosition = [];
      for (int i = 0; i < _arr.length; i++) {
        _curPosition.add(0.0);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initStatesByArr(_generateRandomList(6, 100));
  }

  // void _test1() {
  //   setState(() {
  //     _children = [];
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _children,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                width: 100, // <-- Your width
                height: 40,
                  child: ElevatedButton(
                  onPressed: _bubbleSort,
                  child: const Text("Random"),
                  ),
                ),
                SizedBox(width: 40,),
                SizedBox(
                  width: 100, // <-- Your width
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _bubbleSort,
                    child: const Text("Sort"),
                  ),
                ),
              ],
            )
          ],
        ),
    );
  }
}


class BoxWidget extends StatelessWidget {
  final Animation<Offset> position;
  final Color color;
  final double height;
  final double width;
  final double margin;

  const BoxWidget(
      {Key? key, required this.position, required this.color,
  required this.height, required this.width, required this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: position,
        child: Container(
          margin: EdgeInsets.all(margin),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text("${height.toInt() ~/ 2}", style: Theme.of(context).textTheme.overline,),),
        )
    );
  }
}




