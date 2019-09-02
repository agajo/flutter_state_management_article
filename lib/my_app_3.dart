import 'package:flutter/material.dart';

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp3 is built');
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
  final WidgetD _widgetD = WidgetD();
  int _counter = 0;
  void increment() => setState(() => _counter++);
  void initState() {
    super.initState();
    // WidgetAのコンストラクタにincrement関数を渡しておく
    _widgetA = WidgetA(incrementer: increment);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetA,
        WidgetB(child: WidgetC(count: _counter, child: _widgetD)),
      ],
    );
  }
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
  WidgetB({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    print('WidgetB is built');
    return child;
  }
}

class WidgetC extends StatelessWidget {
  WidgetC({this.count, this.child});
  final Widget child;
  final int count;
  @override
  Widget build(BuildContext context) {
    print('WidgetC is built.');
    return Column(
      children: <Widget>[
        Text(count.toString()),
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
