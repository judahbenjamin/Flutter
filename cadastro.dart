import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListaNomesTela(),
    );
  }
}

class ListaNomesTela extends StatefulWidget {
  const ListaNomesTela({super.key});

  @override
  createState() => _ListaNomesTelaState();
}

class _ListaNomesTelaState extends State<ListaNomesTela> {
  final TextEditingController _nomeController = TextEditingController();
  String? _nome;
  final List<String> _listanomes = [];

  void _addName() {
    if (_nome != null && _nome!.isNotEmpty) {
      setState(() {
        _listanomes.add(_nome!);
        _nomeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Nomes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           
					  Expanded(
              child: ListView.builder(
                itemCount: _listanomes.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_listanomes[index]),
                ),
              ),
            ),

            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _nome = value,
            ),
            const SizedBox(height: 12),
            
						ElevatedButton(
              onPressed: _addName,
              child: const Text('Registrar'),
            ),

          ],
        ),
      ),
    );
  }
}
