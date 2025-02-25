import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool exibirNovoLayout = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primeira página em Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  exibirNovoLayout = true;
                });
              },
              child: const Text('Botão 1'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Função a ser executada quando o botão for pressionado
              },
              child: const Text('Botão 2'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Função a ser executada quando o botão for pressionado
              },
              child: const Text('Botão 3'),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding( // Adiciona padding para afastar do canto
        padding: const EdgeInsets.only(left: 30.0), // Ajuste o valor conforme necessário
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: () {
              // Função para o novo botão
            },
            child: const Icon(Icons.add), // Você pode usar um ícone ou texto
          ),
        ),
      ),
    );
  }
}
