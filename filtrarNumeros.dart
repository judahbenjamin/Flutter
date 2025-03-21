import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filtro',
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
  final TextEditingController _numeroController = TextEditingController();
  String? _nome;
  final List<int> _listaNumeros = [];
  List<int> _listaFiltrada = [];
  bool _filtrado = false; // Adicionada variável para rastrear se a lista está filtrada

  void _adicionarNumero() {
    if (_nomeController.text.isNotEmpty) {
      try {
        int numero = int.parse(_nomeController.text);
        setState(() {
          if (_filtrado) {
            _listaFiltrada.add(numero); // Adiciona à lista filtrada se estiver filtrado
          } else {
            _listaNumeros.add(numero); // Adiciona à lista original se não estiver filtrado
          }
          _nomeController.clear();
        });
      } catch (e) {
        _mostrarMensagemErro('Por favor, insira um número válido.');
      }
    }
  }

  void _filtrarNumeros() {
    if (_numeroController.text.isNotEmpty) {
      try {
        int numeroFiltro = int.parse(_numeroController.text);
        setState(() {
          _listaFiltrada = _listaNumeros.where((numero) => numero > numeroFiltro).toList();
          _filtrado = true; // Define como filtrado
        });
      } catch (e) {
        _mostrarMensagemErro('Por favor, insira um número válido para o filtro.');
      }
    }
  }

  void _mostrarMensagemErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filtro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _filtrado ? _listaFiltrada.length : _listaNumeros.length, // Usa _filtrado para determinar qual lista exibir
                itemBuilder: (context, index) => ListTile(
                  title: Text(_filtrado ? _listaFiltrada[index].toString() : _listaNumeros[index].toString()),
                ),
              ),
            ),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Número',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _numeroController,
              decoration: const InputDecoration(
                labelText: 'Valor do filtro',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _adicionarNumero,
                  child: const Text('Inserir'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _filtrarNumeros,
                  child: const Text('Filtrar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

