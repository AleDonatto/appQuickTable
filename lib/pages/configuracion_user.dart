import 'package:flutter/material.dart';
import 'package:quicktable/widgets/menu.dart';

class ConfiguracionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color.fromRGBO(3, 85, 216, 1),
        actions: [],
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: <StretchMode>[
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
            StretchMode.fadeTitle,
          ],
          centerTitle: true,
          title: const Text('Configuracion'),
        ),
      ),
      drawer: _menuOptions(),
    );
  }

  Widget _menuOptions() {
    return MenuDrawer();
  }
}
