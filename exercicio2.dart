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
      body: exibirNovoLayout ? _novoLayoutTabela() : _layoutPadrao(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                exibirNovoLayout = !exibirNovoLayout;
              });
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovoLayoutTextosLongos(textos: [
                    'A jornada de mil milhas começa com um único passo.',
                    'A persistência realiza o impossível.',
                    'A sabedoria é a filha da experiência.',
                    'A verdadeira medida de um homem é como ele trata alguém que não pode fazer absolutamente nada por ele.',
                  ]),
                ),
              );
            },
            child: const Text('Botão 1'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovoLayoutTextosLongos(textos: [
                    'Acredite em si mesmo e você estará no caminho certo.',
                    'A vida de um escritor é solitária.',
                    'O oceano fascina a humanidade.',
                    'IA revoluciona a sociedade.',
                  ]),
                ),
              );
            },
            child: const Text('Botão 2'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovoLayoutTextosLongos(textos: [
                    'O tempo cura todas as feridas.',
                    'A esperança é a última que morre.',
                    'A união faz a força.',
                    'A prática leva à perfeição.',
                  ]),
                ),
              );
            },
            child: const Text('Botão 3'),
          ),
        ],
      ),
    );
  }

  Widget _novoLayoutTabela() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Text(
              'Tabela de Dados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            children: const [
              TableRow(children: [
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 1, Linha 1'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 2, Linha 1'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 3, Linha 1'))),
              ]),
              TableRow(children: [
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 1, Linha 2'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 2, Linha 2'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 3, Linha 2'))),
              ]),
              TableRow(children: [
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 1, Linha 3'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 2, Linha 3'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 3, Linha 3'))),
              ]),
              TableRow(children: [
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 1, Linha 4'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 2, Linha 4'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Coluna 3, Linha 4'))),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  exibirNovoLayout = false;
                });
              },
              child: const Text('Voltar'),
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
          MaterialPageRoute(builder: (context) => const NovoLayoutQuadradoImagem()),
        );
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
      ),
    );
  }
}

class NovoLayoutQuadradoImagem extends StatelessWidget {
  const NovoLayoutQuadradoImagem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Layout Quadrado'),
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
                  child: const Center(
                    child: Text('Conteúdo do quadrado'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NovoLayoutTextosLongos extends StatelessWidget {
  final List<String> textos;

  const NovoLayoutTextosLongos({super.key, required this.textos});

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
            const SizedBox(height: 120),
            Expanded(
              child: ListView.builder(
                itemCount: textos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(textos[index], style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 2),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NovoLayoutQuadradoImagem()),
                            );
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
