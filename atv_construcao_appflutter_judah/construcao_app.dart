import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        '/inserir': (context) => InserirPage(),
        '/listar': (context) => ListarPage(),
        '/editar_lista': (context) => ListaEditadosPage(),
        '/excluir_lista': (context) => ListaExcluidosPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(context, 'INSERIR', '/inserir'),
            SizedBox(height: 20),
            _buildButton(context, 'LISTAR', '/listar'),
            SizedBox(height: 20),
            _buildButton(context, 'EDITAR', '/editar_lista'),
            SizedBox(height: 20),
            _buildButton(context, 'EXCLUIR', '/excluir_lista'),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String route) {
    return Container(
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.grey),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

class InserirPage extends StatefulWidget {
  @override
  _InserirPageState createState() => _InserirPageState();
}

class _InserirPageState extends State<InserirPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomeMaeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserir'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o CPF';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o e-mail';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomeMaeController,
                decoration: InputDecoration(labelText: 'Nome da Mãe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome da mãe';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o endereço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o telefone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    dadosCadastrados.add({
                      'nome': _nomeController.text,
                      'cpf': _cpfController.text,
                      'email': _emailController.text,
                      'nomeMae': _nomeMaeController.text,
                      'endereco': _enderecoController.text,
                      'telefone': _telefoneController.text,
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListarPage(),
                      ),
                    );
                  }
                },
                child: Text('INSERIR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Map<String, String>> dadosCadastrados = [];
List<Map<String, String>> dadosEditados = [];
List<Map<String, String>> dadosExcluidos = [];

class ListarPage extends StatefulWidget {
  @override
  _ListarPageState createState() => _ListarPageState();
}

class _ListarPageState extends State<ListarPage> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados Cadastrados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: dadosCadastrados.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedIndex == index ? Colors.blue : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Nome: ${dadosCadastrados[index]['nome']}'),
                          Text('CPF: ${dadosCadastrados[index]['cpf']}'),
                          Text('E-mail: ${dadosCadastrados[index]['email']}'),
                          Text('Nome da Mãe: ${dadosCadastrados[index]['nomeMae']}'),
                          Text('Endereço: ${dadosCadastrados[index]['endereco']}'),
                          Text('Telefone: ${dadosCadastrados[index]['telefone']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async { // Adicionado async
                    if (_selectedIndex != null) {
                      final result = await Navigator.push( // Adicionado await
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPage(index: _selectedIndex!),
                        ),
                      );
                      if (result == true) { // Verifica o valor de retorno
                        setState(() {}); // Atualiza a tela ListarPage
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selecione um cliente para editar')),
                      );
                    }
                  },
                  child: Text('EDITAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedIndex != null) {
                      dadosExcluidos.add(dadosCadastrados[_selectedIndex!]);
                      dadosCadastrados.removeAt(_selectedIndex!);
                      setState(() {
                        _selectedIndex = null;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selecione um cliente para excluir')),
                      );
                    }
                  },
                  child: Text('EXCLUIR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  },
                  child: Text('VOLTAR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditarPage extends StatefulWidget {
  final int? index;

  EditarPage({this.index});

  @override
  _EditarPageState createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomeMaeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      _nomeController.text = dadosCadastrados[widget.index!]['nome']!;
      _cpfController.text = dadosCadastrados[widget.index!]['cpf']!;
      _emailController.text = dadosCadastrados[widget.index!]['email']!;
      _nomeMaeController.text = dadosCadastrados[widget.index!]['nomeMae']!;
      _enderecoController.text = dadosCadastrados[widget.index!]['endereco']!;
      _telefoneController.text = dadosCadastrados[widget.index!]['telefone']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o CPF';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o e-mail';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomeMaeController,
                decoration: InputDecoration(labelText: 'Nome da Mãe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome da mãe';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o endereço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o telefone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    dadosEditados.add(dadosCadastrados[widget.index!]);
                    dadosCadastrados[widget.index!] = {
                      'nome': _nomeController.text,
                      'cpf': _cpfController.text,
                      'email': _emailController.text,
                      'nomeMae': _nomeMaeController.text,
                      'endereco': _enderecoController.text,
                      'telefone': _telefoneController.text,
                    };

                    Navigator.pop(context, true); // Adicionado valor de retorno
                  }
                },
                child: Text('SALVAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaEditadosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itens Editados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dadosEditados.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Nome: ${dadosEditados[index]['nome']}'),
                    Text('CPF: ${dadosEditados[index]['cpf']}'),
                    Text('E-mail: ${dadosEditados[index]['email']}'),
                    Text('Nome da Mãe: ${dadosEditados[index]['nomeMae']}'),
                    Text('Endereço: ${dadosEditados[index]['endereco']}'),
                    Text('Telefone: ${dadosEditados[index]['telefone']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ListaExcluidosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itens Excluídos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dadosExcluidos.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Nome: ${dadosExcluidos[index]['nome']}'),
                    Text('CPF: ${dadosExcluidos[index]['cpf']}'),
                    Text('E-mail: ${dadosExcluidos[index]['email']}'),
                    Text('Nome da Mãe: ${dadosExcluidos[index]['nomeMae']}'),
                    Text('Endereço: ${dadosExcluidos[index]['endereco']}'),
                    Text('Telefone: ${dadosExcluidos[index]['telefone']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
