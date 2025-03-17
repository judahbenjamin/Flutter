import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora com Dois Formulários',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _numero1Controller1 = TextEditingController();
  final _numero2Controller1 = TextEditingController();
  final _numero1Controller2 = TextEditingController();
  final _numero2Controller2 = TextEditingController();

  String _operador1 = 'SOMAR';
  String _operador2 = 'SOMAR';

  double _resultado1 = 0;
  double _resultado2 = 0;

  void _calcular1() {
    if (_formKey1.currentState!.validate()) {
      double numero1 = double.parse(_numero1Controller1.text);
      double numero2 = double.parse(_numero2Controller1.text);

      setState(() {
        switch (_operador1) {
          case 'SOMAR':
            _resultado1 = numero1 + numero2;
            break;
          case 'SUBTRAIR':
            _resultado1 = numero1 - numero2;
            break;
          case 'MULTIPLICAR':
            _resultado1 = numero1 * numero2;
            break;
          case 'DIVIDIR':
            if (numero2 != 0) {
              _resultado1 = numero1 / numero2;
            } else {
              _resultado1 = double.infinity;
            }
            break;
        }
      });
    }
  }

  void _calcular2() {
    if (_formKey2.currentState!.validate()) {
      double numero1 = double.parse(_numero1Controller2.text);
      double numero2 = double.parse(_numero2Controller2.text);

      setState(() {
        switch (_operador2) {
          case 'SOMAR':
            _resultado2 = numero1 + numero2;
            break;
          case 'SUBTRAIR':
            _resultado2 = numero1 - numero2;
            break;
          case 'MULTIPLICAR':
            _resultado2 = numero1 * numero2;
            break;
          case 'DIVIDIR':
            if (numero2 != 0) {
              _resultado2 = numero1 / numero2;
            } else {
              _resultado2 = double.infinity;
            }
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora com Dois Formulários'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: _formKey1,
                child: Column(
                  children: [
                    Text('PRIMEIRO'),
                    TextFormField(
                      controller: _numero1Controller1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Número 1'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um número';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _numero2Controller1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Número 2'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um número';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: _calcular1,
                      child: Text('CALCULAR'),
                    ),
                    Text('Resultado: $_resultado1'),
                    Text('SOMAR DOIS NÚMEROS'),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Form(
                key: _formKey2,
                child: Column(
                  children: [
                    Text('SEGUNDO'),
                    TextFormField(
                      controller: _numero1Controller2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Número 1'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um número';
                        }
                        return null;
                      },
                    ),
                    DropdownButton<String>(
                      value: _operador2,
                      onChanged: (String? newValue) {
                        setState(() {
                          _operador2 = newValue!;
                        });
                      },
                      items: <String>[
                        'SOMAR',
                        'SUBTRAIR',
                        'MULTIPLICAR',
                        'DIVIDIR'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: _numero2Controller2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Número 2'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um número';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: _calcular2,
                      child: Text('CALCULAR'),
                    ),
                    Text('Resultado: $_resultado2'),
                    Text('CUIDADO COM O DIVIDIR POR ZERO'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
