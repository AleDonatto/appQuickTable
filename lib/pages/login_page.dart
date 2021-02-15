import 'package:flutter/material.dart';
import 'package:quicktable/blocs/provider.dart';
import 'package:quicktable/utils/api_laravel.dart';
import 'package:quicktable/utils/preferenciasUsuario.dart';

class LoginPage extends StatelessWidget {
  final ApiLaravel _apiLaravel = new ApiLaravel();
  final _prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _createFondo(context),
          _formLogin(context),
        ],
      ),
    );
  }

  Widget _createFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _fondo = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(90, 70, 178, 1.0),
        ]),
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    return Stack(
      children: <Widget>[
        _fondo,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50, right: -20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.casino,
                color: Colors.white,
                size: 100.0,
              ),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Text(
                'QuickTable',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _formLogin(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 60.0),
                _createEmail(bloc),
                SizedBox(height: 20.0),
                _createPassword(bloc),
                SizedBox(height: 20.0),
                _createButton(bloc),
                SizedBox(
                  height: 5.0,
                ),
                Text('o ingrese con'),
                SizedBox(
                  height: 5.0,
                ),
                _createButtonGoogle(),
                SizedBox(
                  height: 5.0,
                ),
                _createButtonFacebook(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createButtonGoogle() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Google'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      color: Colors.red[600],
      textColor: Colors.white,
      onPressed: () {},
    );
  }

  Widget _createButtonFacebook() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Facebook'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      color: Colors.blue[900],
      textColor: Colors.white,
      onPressed: () {},
    );
  }

  Widget _createEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext contex, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(
                Icons.alternate_email,
                color: Colors.blue[600],
              ),
              hintText: 'example@example.com',
              labelText: 'Email',
              errorText: snapshot.error,
            ),
            onChanged: (value) {
              bloc.changeEmail(value);
            },
          ),
        );
      },
    );
  }

  Widget _createPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline,
                color: Colors.blue[600],
              ),
              labelText: 'Password ',
              errorText: snapshot.error,
            ),
            onChanged: (value) {
              bloc.changePassword(value);
            },
          ),
        );
      },
    );
  }

  Widget _createButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    //navegar a otro pagina
    Map info = await _apiLaravel.loginAPI(bloc.email, bloc.password);

    if (!info['ok']) {
      _showAlert(context, info["mensaje"]);
    } else {
      print(_prefs.name);
      print(_prefs.lastname);
      print(_prefs.id);
      print(_prefs.token);
      Navigator.pushReplacementNamed(context, 'home');
    }
  }

  _showAlert(BuildContext context, String msj) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Login"),
          content: Text(msj),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
