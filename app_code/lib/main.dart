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

  late Color _boxColor = Colors.orangeAccent;
  double _boxWidth = 20;
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

          await Future.delayed(Duration(seconds: 1));
          _afterAnimateSwap(j, j + 1);

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
        }
      }
    }
  }


  void _childrenUpdateHelper() {
    for (int i = 0; i < _arr.length; i++) {
      Key curKey = UniqueKey();
      _keys.add(curKey);
      _children.add(
        BoxWidget(
          key: curKey,
          color: _boxColor,
          position: _offsetAnimation[i],
          height: _arr[i] * 2,
          width: _boxWidth,
          margin: _boxMargin,
        ),
      );
    }
  }
  
  void _beforeSwapTwoWidgetByIndex(int i, int j) {
    print("current index: " + i.toString() + " ," + j.toString());
    print("current keyNum: " + _indToKeyNum[i].toString() + " ," + _indToKeyNum[j].toString());

    double distanceForI = (j - i).toDouble();

    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _boxColor,
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
            color: _boxColor,
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

  void _swapTest() {
    int i = 5; int j = 2;
    _beforeSwapTwoWidgetByIndex(i, j);
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _arr = [100,69,30,20,78,58];
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
    _children = [];
    _childrenUpdateHelper();
    _curPosition = [];
    for (int i = 0; i < _arr.length; i++) {
      _curPosition.add(0.0);
    }
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
            ElevatedButton(
              onPressed: _childrenUpdateHelper,
              child: const Text("Create"),
            ),
            ElevatedButton(
              onPressed: _bubbleSort,
              child: const Text("swap"),
            ),
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
          color: color,
        ),
    );
  }
}




