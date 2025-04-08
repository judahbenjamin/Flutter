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
      theme: ThemeData(primarySwatch: Colors.blueGrey),
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

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(22.0),
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
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
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _output,
                style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                _expression.replaceAll('*', '×').replaceAll('/', '÷'),
                style: TextStyle(fontSize: 24.0, color: Colors.grey[600]),
              ),
            ),
            Expanded(child: Divider()),
            Column(
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
      });
    } else if (buttonText == 'DEL') {
      setState(() {
        _output = _output.length > 1 ? _output.substring(0, _output.length - 1) : '0';
      });
    } else if (buttonText == '=') {
      try {
        Parser p = Parser();
        Expression exp = p.parse(_expression);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        setState(() {
          _output = eval.toString();
          _expression = '';
        });
      } catch (e) {
        setState(() {
          _output = 'Erro';
        });
      }
    } else {
      setState(() {
        if (_output == '0' && buttonText != '.') {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
        if (buttonText != '=') {
          if (['+', '-', '*', '/'].contains(buttonText)) {
            _expression = _output;
            _output = '0'; // Prepare for the next number
          } else {
            _expression = _output;
          }
        }
      });
    }
  }
}