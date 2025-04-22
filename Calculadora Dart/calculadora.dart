//POR JUDAH BENJAMIN - CEET VASCO COUTINHO 2025
//CALCULADORA FLUTTER

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo[700],
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.grey[300],
            padding: EdgeInsets.all(20.0),
            textStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _output = '0';
  String _expression = '';
  bool _justCalculated = false; // Flag para indicar se o último botão foi '='

  Widget _buildButton(String buttonText) {
    Color buttonColor = Colors.grey[300]!;
    Color textColor = Colors.black;
    if (['/', '*', '-', '+', '='].contains(buttonText)) {
      buttonColor = Colors.amber[700]!;
      textColor = Colors.white;
    } else if (['C', 'DEL'].contains(buttonText)) {
      buttonColor = Colors.redAccent[400]!;
      textColor = Colors.white;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: textColor,
            backgroundColor: buttonColor,
            padding: EdgeInsets.all(22.0),
            textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(buttonText),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((text) => _buildButton(text)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora')),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                child: Text(
                  _output,
                  style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                _expression.replaceAll('*', '×').replaceAll('/', '÷'),
                style: TextStyle(fontSize: 28.0, color: Colors.grey[700]),
              ),
            ),
            Divider(color: Colors.grey[400]),
            Flexible(
              flex: 2,
              child: Column(
                children: <Widget>[
                  _buildRow(['7', '8', '9', '/']),
                  _buildRow(['4', '5', '6', '*']),
                  _buildRow(['1', '2', '3', '-']),
                  _buildRow(['0', '.', '=', '+']),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildButton('C'),
                        _buildButton('DEL'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buttonPressed(String buttonText) {
    if (buttonText == 'C') {
      setState(() {
        _output = '0';
        _expression = '';
        _justCalculated = false;
      });
    } else if (buttonText == 'DEL') {
      setState(() {
        _output = _output.length > 1 ? _output.substring(0, _output.length - 1) : '0';
        if (_output == '') _output = '0';
        _justCalculated = false;
      });
    } else if (['+', '-', '*', '/'].contains(buttonText)) {
      setState(() {
        if (_justCalculated) {
          _expression = _output + buttonText;
          _output = '0';
          _justCalculated = false;
        } else if (_expression.isEmpty && _output == '0' && buttonText == '-') {
          _output = '-';
        } else if (_output != '0') {
          _expression += _output + buttonText;
          _output = '0';
        }
        _justCalculated = false; // Um operador foi pressionado, então não acabamos de calcular
      });
    } else if (buttonText == '=') {
      // Agora a expressão deve incluir o último número digitado no _output
      if (_expression.isNotEmpty) {
        try {
          print('Expressão a ser avaliada: $_expression$_output'); // Incluímos o _output aqui
          Parser p = Parser();
          Expression exp = p.parse(_expression + _output); // Avalia a expressão completa
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          setState(() {
            _output = eval.toString();
            _expression = '';
            _justCalculated = true;
          });
        } catch (e) {
          setState(() {
            _output = 'Erro';
            _expression = '';
            _justCalculated = false;
          });
          print('Erro ao avaliar a expressão: $e');
        }
      } else if (_output != '0') {
        setState(() {
          _expression = '';
          _justCalculated = true;
        });
      } else {
        setState(() {
          _output = '0';
          _expression = '';
          _justCalculated = false;
        });
      }
    } else if (buttonText == '.') {
      setState(() {
        if (!_output.contains('.')) {
          _output += buttonText;
          _justCalculated = false;
        }
      });
    } else {
      setState(() {
        if (_output == '0' || _justCalculated) {
          _output = buttonText;
          _justCalculated = false;
        } else {
          _output += buttonText;
        }
      });
    }
  }
}
