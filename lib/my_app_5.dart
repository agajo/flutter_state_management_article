import 'package:flutter/material.dart';

class MyApp5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp5 is built');
    return HogeWidget();
  }
}

class HogeWidget extends StatelessWidget {
  final _HogeChangeNotifier _hogeChangeNotifier = _HogeChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WidgetA(_hogeChangeNotifier),
        WidgetB(_hogeChangeNotifier),
      ],
    );
  }
}

class _HogeChangeNotifier extends ChangeNotifier {
  int _counter = 0;
  void increment() {
    _counter++;
    notifyListeners();
  }
}

class WidgetA extends StatelessWidget {
  WidgetA(this._hogeChangeNotifier);
  final _HogeChangeNotifier _hogeChangeNotifier;
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      // 受け取っているChangeNotifierのincrement関数を呼ぶ
      onPressed: () => _hogeChangeNotifier.increment(),
    );
  }
}

class WidgetB extends StatelessWidget {
  WidgetB(this._hogeChangeNotifier);
  final _HogeChangeNotifier _hogeChangeNotifier;
  final WidgetD _widgetD = WidgetD();
  @override
  Widget build(BuildContext context) {
    print('WidgetB is built');
    return WidgetC(_hogeChangeNotifier, child: _widgetD);
  }
}

class WidgetC extends StatefulWidget {
  WidgetC(this._hogeChangeNotifier, {this.child});
  final _HogeChangeNotifier _hogeChangeNotifier;
  final Widget child;

  @override
  _WidgetCState createState() => _WidgetCState();
}

class _WidgetCState extends State<WidgetC> {
  void rebuildC() => setState(() {});
  @override
  Widget build(BuildContext context) {
    print('WidgetCState is built.');
    // listnerとしてリビルドを登録したいので、WidgetCをStatefulWidgetにしてsetStateをlistner登録
    widget._hogeChangeNotifier.addListener(rebuildC);
    return Column(
      children: <Widget>[
        Text(widget._hogeChangeNotifier._counter.toString()),
        widget.child,
      ],
    );
  }

  // 古い_WidgetCStateが捨てられるたびに、登録した古いlistenerを解除しておく
  @override
  dispose() {
    widget._hogeChangeNotifier.removeListener(rebuildC);
    super.dispose();
  }
}

class WidgetD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetD is built.');
    return Text('WidgetD');
  }
}
