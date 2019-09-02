import 'package:flutter/material.dart';

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp2 is built');
    return HogeStatefulWidget();
  }
}

class HogeStatefulWidget extends StatefulWidget {
  @override
  _HogeStatefulWidgetState createState() => _HogeStatefulWidgetState();
}

class _HogeStatefulWidgetState extends State<HogeStatefulWidget> {
  // WidgetAとWidgetDのコンストラクタはbuild()内で呼ばないので、setState()時にリビルドされない
  final WidgetA _widgetA = WidgetA();
  final WidgetD _widgetD = WidgetD();
  int _counter = 0;
  void increment() => setState(() => _counter++);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetA,
        WidgetB(child: WidgetC(count: _counter, child: _widgetD)),
      ],
    );
  }

  // 与えられた「context」の地点からWidgetツリーを遡ってこのStateを見つけてくるstatic関数
  static _HogeStatefulWidgetState of(BuildContext context) =>
      context.ancestorStateOfType(TypeMatcher<_HogeStatefulWidgetState>());
}

class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      // ここからWidgetツリーを遡ってStateを探し、increment()を呼びます。
      onPressed: () => _HogeStatefulWidgetState.of(context).increment(),
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
