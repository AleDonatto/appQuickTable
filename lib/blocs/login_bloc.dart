import 'dart:async';
import 'package:quicktable/blocs/validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  //libreria rxdart no reconoce StreamController
  //final _emailController = StreamController<String>.broadcast();
  //final _passwordController = StreamController<String>.broadcast();

  //en su lugar se ocupa
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //recuperar los datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //obtener ultimos valores enviados
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
