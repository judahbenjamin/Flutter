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
      body: exibirNovoLayout ? _novoLayout() : _layoutPadrao(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: () {
              // Função para o novo botão
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _layoutPadrao() {
    return Center(
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
    );
  }

  Widget _novoLayout() {
    final List<String> textosCompletos = [
      'A jornada de mil milhas começa com um único passo.',
      'A persistência realiza o impossível.',
      'A sabedoria é a filha da experiência.',
      'A verdadeira medida de um homem é como ele trata alguém que não pode fazer absolutamente nada por ele.',
      'A vida é o que acontece enquanto você está ocupado fazendo outros planos.',
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Text(
              'Título',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: textosCompletos.map((texto) => Text(texto)).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) => _buildQuadrado(index)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  exibirNovoLayout = false;
                });
              },
              child: const Text('Botão'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuadrado(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NovoLayoutQuadrado()),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
      ),
    );
  }
}

class NovoLayoutQuadrado extends StatelessWidget {
  const NovoLayoutQuadrado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Layout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                'Título',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Volta para a tela anterior
                },
                child: const Text('Botão'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
