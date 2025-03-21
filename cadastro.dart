import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela Cadastro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MontaTela(),
    );
  }
}

class MontaTela extends StatefulWidget {
  const MontaTela({super.key});
  @override
  StatusTelaAplicativo createState() => StatusTelaAplicativo();
}

class StatusTelaAplicativo extends State<MontaTela> {
  final TextEditingController _controller = TextEditingController();
  String _nome = ' ';

  void _atualizarNome() {
    setState(() {
      _nome = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column (
        mainAxisAlignment: MainAxisAlignment.center,

          children: [

            TextField (
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _atualizarNome,
              child: const Text('Registrar'),
            ),
            const SizedBox(height: 20),

            Text(
              _nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

}
