import 'package:flutter/material.dart';
import 'package:quicktable/blocs/login_bloc.dart';
export 'package:quicktable/blocs/login_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instancias;

  factory Provider({Key key, Widget child}) {
    if (_instancias == null) {
      _instancias = new Provider._internal(key: key, child: child);
    }
    return _instancias;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
