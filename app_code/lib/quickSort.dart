import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class _QuickSortVisualizerState extends State<QuickSortVisualizer>
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
  Color _swapColor1 = Colors.lightBlue;
  Color _swapColor2 = Colors.lightBlue;
  Color _notSwapColor = Colors.deepOrange;
  Color _doneColor = Colors.lightGreen;
  Color _iColor = Colors.orangeAccent;
  Color _jColor = Colors.white;
  Color _pivotColor = Colors.purpleAccent;
  double _boxWidth = 25;
  double _boxMargin = 10;







  void _quickSort() {
    print(_arr.toString());
    _quickSortRec(_arr, 0, _arr.length - 1);
    print(_arr.toString());
  }

  Future<void> _quickSortRec(List<int> list, int low, int high) async {
    if (low == high) {
      await Future.delayed(Duration(seconds: 1));
      _doneColorAnimation(low);
    }
    else if (low < high) {
      await Future.delayed(Duration(seconds: 1));
      int pi = await _partition(list, low, high);
      print("pivot: ${list[pi]} now at index $pi");

      await Future.delayed(Duration(seconds: 1));
      _doneColorAnimation(pi);

      await _quickSortRec(list, low, pi - 1);
      await _quickSortRec(list, pi + 1, high);
    }
  }

  Future<int> _partition(List<int> list, low, high) async {
    // Base check
    if (list.isEmpty) {
      return 0;
    }
    // Take our last element as pivot and counter i one less than low
    int pivot = list[high];
    await Future.delayed(Duration(seconds: 1));
    _pivotColorAnimation(high);


    int i = low - 1;

    for (int j = low; j < high; j++) {

      // When j is < than pivot element we increment i and swap arr[i] and arr[j]
      await Future.delayed(Duration(seconds: 1));
      // _jPointerAnimation(j);
      _jPointerAnimation(j);
      await Future.delayed(Duration(seconds: 1));
      _jPointerCancelAnimation(j);



      if (list[j] < pivot) {



        i++;


        await _swap1(list, i, j);
      }
    }
    // Swap the last element and place in front of the i'th element
    await _swap2(list, i + 1, high);
    return i + 1;
  }

// Swapping using a temp variable
  Future<void> _swap2(List list, int i, int j) async {
    await Future.delayed(Duration(seconds: 1));
    // animate
    _beforeAnimateSwap2(i, j);

    // also update the _indToKeyNum
    setState(() {
      int temp2 = _indToKeyNum[i];
      _indToKeyNum[i] = _indToKeyNum[j];
      _indToKeyNum[j] = temp2;
    });

    setState(() {
      int temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    });

    await Future.delayed(Duration(seconds: 1));
    _afterAnimateSwap2(i, j);
  }

  // Swapping using a temp variable
  Future<void> _swap1(List list, int i, int j) async {
    await Future.delayed(Duration(seconds: 1));
    // animate
    _beforeAnimateSwap1(i, j);

    // also update the _indToKeyNum
    setState(() {
      int temp2 = _indToKeyNum[i];
      _indToKeyNum[i] = _indToKeyNum[j];
      _indToKeyNum[j] = temp2;
    });

    setState(() {
      int temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    });

    await Future.delayed(Duration(seconds: 1));
    _afterAnimateSwap1(i, j);
  }





  void _pivotColorAnimation(int i) {
    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _pivotColor,
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

  void _jPointerAnimation(int i) {
    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _jColor,
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

  void _jPointerAnimationWithArrow(int i) {
    setState(() {
      _children[_indToKeyNum[i]] =
      Column(
        children: [
          Text("j", style: TextStyle(color: Colors.white),),
          BoxWidget(
          key: _keys[_indToKeyNum[i]],
            color: _jColor,
            position: Tween<Offset>(
              begin: Offset(_curPosition[_indToKeyNum[i]], 0.0),
              end: Offset(_curPosition[_indToKeyNum[i]], 0.0),
            ).animate(_controller),
            height: _widgetHeight[_indToKeyNum[i]],
            width: _boxWidth,
            margin: _boxMargin,
          ),
        ],
      );

    });
  }



  void _jPointerCancelAnimation(int i) {
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
    });
  }

  void _iPointerAnimationWithArrow(int i) {
    setState(() {
      _children[_indToKeyNum[i]] =
          Column(
            children: [
              Text("i", style: TextStyle(color: Colors.white),),
              BoxWidget(
                key: _keys[_indToKeyNum[i]],
                color: _jColor,
                position: Tween<Offset>(
                  begin: Offset(_curPosition[_indToKeyNum[i]], 0.0),
                  end: Offset(_curPosition[_indToKeyNum[i]], 0.0),
                ).animate(_controller),
                height: _widgetHeight[_indToKeyNum[i]],
                width: _boxWidth,
                margin: _boxMargin,
              ),
            ],
          );

    });
  }

  void _iPointerCancelAnimation(int i) {
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
    });
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

  void _beforeSwapTwoWidgetByIndex1(int i, int j) {
    // print("current index: " + i.toString() + " ," + j.toString());
    // print("current keyNum: " + _indToKeyNum[i].toString() + " ," + _indToKeyNum[j].toString());

    double distanceForI = (j - i).toDouble();

    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _swapColor1,
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
            color: _swapColor1,
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

  void _beforeSwapTwoWidgetByIndex2(int i, int j) {
    // print("current index: " + i.toString() + " ," + j.toString());
    // print("current keyNum: " + _indToKeyNum[i].toString() + " ," + _indToKeyNum[j].toString());

    double distanceForI = (j - i).toDouble();

    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _swapColor2,
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
            color: _pivotColor,
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

  void _afterSwapTwoWidgetByIndex1(int i, int j) {
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

  void _afterSwapTwoWidgetByIndex2(int i, int j) {
    setState(() {
      _children[_indToKeyNum[i]] =
          BoxWidget(
            key: _keys[_indToKeyNum[i]],
            color: _pivotColor,
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

  void _beforeAnimateSwap1(int i, int j) {
    _beforeSwapTwoWidgetByIndex1(i, j);
    _controller.forward(from: 0.0);
  }

  void _beforeAnimateSwap2(int i, int j) {
    _beforeSwapTwoWidgetByIndex2(i, j);
    _controller.forward(from: 0.0);
  }

  void _afterAnimateSwap1(int i, int j) {
    _afterSwapTwoWidgetByIndex1(i, j);
  }

  void _afterAnimateSwap2(int i, int j) {
    _afterSwapTwoWidgetByIndex2(i, j);
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
    // _initStatesByArr([8,7,6,1,0,9,2]);
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
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RichText(
              text: TextSpan(
                text:            "BubbleSort(int[] arr) {\n",
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal),
                children: const <TextSpan>[
                  TextSpan(text: '    int n = arr.length;\n'),
                  TextSpan(text: '    for (int i = 0; i < n - 1; i++) {\n'),
                  TextSpan(text: '      for (int j = 0; j < n - i - 1; j++) {\n'),
                  TextSpan(text: '        if (arr[j] > arr[j + 1]) {\n'),
                  TextSpan(text: '            int temp = arr[j];\n'),
                  TextSpan(text: '            arr[j] = arr[j + 1];\n'),
                  TextSpan(text: '            arr[j + 1] = temp;\n'),
                  TextSpan(text: '        }\n'),
                  TextSpan(text: '      }\n'),
                  TextSpan(text: '    }\n'),
                  TextSpan(text: '}\n'),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          //  Color _boxColor = Colors.orangeAccent;
          //   Color _swapColor = Colors.lightBlue;
          //   Color _notSwapColor = Colors.deepOrange;
          //   Color _doneColor = Colors.lightGreen;
          Container(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal),
                children: <InlineSpan>[
                  WidgetSpan(
                      child: Container(color: _pivotColor, width: 10, height: 10, margin: EdgeInsets.only(right: 8.0),)),
                  TextSpan(text: 'pivot\n'),

                  WidgetSpan(
                      child: Container(color: _swapColor1, width: 10, height: 10, margin: EdgeInsets.only(right: 8.0),)),
                  TextSpan(text: 'swapping\n'),

                  WidgetSpan(
                      child: Container(color: _jColor, width: 10, height: 10, margin: EdgeInsets.only(right: 8.0),)),
                  TextSpan(text: 'j pointer\n'),

                  WidgetSpan(
                      child: Container(color: _doneColor, width: 10, height: 10, margin: EdgeInsets.only(right: 8.0),)),
                  TextSpan(text: 'sorted part\n'),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
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
                  onPressed: _quickSort,
                  child: const Text("Random"),
                ),
              ),
              SizedBox(width: 40,),
              SizedBox(
                width: 100, // <-- Your width
                height: 40,
                child: ElevatedButton(
                  onPressed: _quickSort,
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

class QuickSortVisualizer extends StatefulWidget {
  @override
  _QuickSortVisualizerState createState() => _QuickSortVisualizerState();
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




