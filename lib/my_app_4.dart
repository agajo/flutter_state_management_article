import 'package:flutter/material.dart';

class MyApp4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp4 is built');
    return HogeStatefulWidget();
  }
}

class HogeStatefulWidget extends StatefulWidget {
  @override
  _HogeStatefulWidgetState createState() => _HogeStatefulWidgetState();
}

class _HogeStatefulWidgetState extends State<HogeStatefulWidget> {
  // _widgetAに最初からincrement関数を渡すのは不可能なので、initState内で初期化する
  // (↑initializerの中ではstaticメソッドしか渡せないから)
  WidgetA _widgetA;
  WidgetB _widgetB = WidgetB();
  int _counter = 0;
  void increment() => setState(() => _counter++);
  void initState() {
    super.initState();
    // WidgetAのコンストラクタにincrement関数を渡しておく
    _widgetA = WidgetA(incrementer: increment);
  }

  @override
  Widget build(BuildContext context) {
    // setStateが呼ばれるたびにこのbuild関数が呼ばれ、新しい_HogeInheritedWidgetが作られて古いものと交換される
    return _HogeInheritedWidget(
      counter: _counter,
      child: Column(
        children: <Widget>[
          _widgetA,
          _widgetB,
        ],
      ),
    );
  }
}

class _HogeInheritedWidget extends InheritedWidget {
  _HogeInheritedWidget({Widget child, this.counter}) : super(child: child);
  final int counter;
  @override
  bool updateShouldNotify(_HogeInheritedWidget oldWidget) =>
      oldWidget.counter != counter;
  static _HogeInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_HogeInheritedWidget);
}

class WidgetA extends StatelessWidget {
  // WidgetAはコンストラクタでincrement関数を受け取れる
  WidgetA({this.incrementer});
  final void Function() incrementer;
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      // すでに受け取っているincrement関数を呼ぶだけ
      onPressed: () => incrementer(),
    );
  }
}

class WidgetB extends StatelessWidget {
  final WidgetD _widgetD = WidgetD();
  @override
  Widget build(BuildContext context) {
    print('WidgetB is built');
    return WidgetC(child: _widgetD);
  }
}

class WidgetC extends StatelessWidget {
  WidgetC({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    print('WidgetC is built.');
    return Column(
      children: <Widget>[
        // ここでWidgetCが_HogeInheritedWidgetのリビルド対象として登録される
        Text(_HogeInheritedWidget.of(context).counter.toString()),
        child,
      ],
    );
  }
}

class WidgetD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetD is built.');
    return Text('WidgetD');
  }
}
