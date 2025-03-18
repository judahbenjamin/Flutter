import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraSomaApp());
}

class CalculadoraSomaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Soma',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[200],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber, // Correção aqui
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.blueGrey),
        ),
      ),
      home: CalculadoraSoma(),
    );
  }
}

class CalculadoraSoma extends StatefulWidget {
  @override
  _CalculadoraSomaState createState() => _CalculadoraSomaState();
}

class _CalculadoraSomaState extends State<CalculadoraSoma> {
  final _numero1Controller = TextEditingController();
  final _numero2Controller = TextEditingController();
  int _resultado = 0;

  void _calcularSoma() {
    setState(() {
      _resultado = int.parse(_numero1Controller.text) +
          int.parse(_numero2Controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 200,
              child: TextField(
                controller: _numero1Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número 1',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _numero2Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número 2',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calcularSoma,
              child: Text('Calcular'),
            ),
            SizedBox(height: 24),
            Text(
              'Resultado: $_resultado',
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}
//Abrir o terminal na raiz do código e executar o comando "flutter run"
