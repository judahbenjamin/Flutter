import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _number1Controller = TextEditingController();
  final TextEditingController _number2Controller = TextEditingController();
  String _operator = 'SOMAR';
  double _result = 0;
  String _errorMessage = '';

  void _calculate() {
    setState(() {
      _errorMessage = ''; // Limpa a mensagem de erro anterior

      double number1 = double.tryParse(_number1Controller.text) ?? 0;
      double number2 = double.tryParse(_number2Controller.text) ?? 0;

      switch (_operator) {
        case 'SOMAR':
          _result = number1 + number2;
          break;
        case 'SUBTRAIR':
          _result = number1 - number2;
          break;
        case 'MULTIPLICAR':
          _result = number1 * number2;
          break;
        case 'DIVIDIR':
          if (number2 != 0) {
            _result = number1 / number2;
          } else {
            _errorMessage = 'Erro: Divisão por zero!';
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _number1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número 1',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _operator,
              items: <String>['SOMAR', 'SUBTRAIR', 'MULTIPLICAR', 'DIVIDIR']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _operator = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Operador',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _number2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número 2',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculate,
              child: Text('CALCULAR'),
            ),
            SizedBox(height: 24),
            Text(
              'Resultado: $_result',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
