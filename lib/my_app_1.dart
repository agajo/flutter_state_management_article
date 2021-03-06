import 'package:flutter/material.dart';

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp1 is built');
    return HogeWidget();
  }
}

// WidgetCに渡すためのGlobalKeyを生成しておく
GlobalKey<_WidgetCState> _globalKey = GlobalKey<_WidgetCState>();

class HogeWidget extends StatelessWidget {
  // WidgetAとWidgetDはここで生成したものをずっと使うので、リビルドされることはない
  final WidgetA _widgetA = WidgetA();
  final WidgetD _widgetD = WidgetD();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetA,
        // WidgetCに生成したGlobalKeyを渡しておく
        WidgetB(child: WidgetC(child: _widgetD, key: _globalKey)),
      ],
    );
  }
}

class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      onPressed: () {
        // GlobalKeyを使って、更新関数を直接呼ぶ
        _globalKey.currentState.increment();
      },
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

class WidgetC extends StatefulWidget {
  WidgetC({this.child, Key key}) : super(key: key);
  final Widget child;

  @override
  // グローバル変数であるStateを返す
  _WidgetCState createState() => _WidgetCState();
}

class _WidgetCState extends State<WidgetC> {
  int _count = 0;
  void increment() => setState(() => _count++);
  @override
  Widget build(BuildContext context) {
    print('WidgetCState is built.');
    return Column(
      children: <Widget>[
        Text(_count.toString()),
        widget.child,
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
