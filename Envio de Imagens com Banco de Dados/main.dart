import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Objeto.dart'; 
import 'home_screen.dart';
import 'database_helper.dart';

void main() async {
  // Garante que os bindings do Flutter estejam inicializados.
  // Isso é necessário antes de qualquer operação assíncrona ou de acesso a plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o DatabaseHelper.
  // Ao acessar o getter 'database' de DatabaseHelper(), estamos garantindo
  // que o banco de dados seja inicializado e esteja pronto.
  // O 'await' é crucial aqui para que o aplicativo não comece a construir a UI
  // antes que o banco de dados esteja acessível, evitando erros de 'Null'.
  await DatabaseHelper().database;

  // Uma vez que o banco de dados está pronto, o aplicativo principal pode ser executado.
  runApp(const MyApp());
}

// A CLASSE ExemploGravaBanco SERÁ MODIFICADA OU REUTILIZADA EM OUTRAS TELAS.
// Por enquanto, vamos manter a classe _ExemploGravaBancoState com toda a lógica de BD,
// mas REMOVER (ou comentar) o método `build` dela,
// pois a UI será definida pelas novas telas.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Coisas!', // Título do aplicativo
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a cor primária do tema
        // Adiciona um VisualDensity adaptativo para melhor aparência
        // em diferentes plataformas (Android, iOS, etc.).
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(), // Define a HomeScreen como a tela inicial do aplicativo
      debugShowCheckedModeBanner: false, // Remove o banner "DEBUG" do canto superior direito
    );
  }
}

class ExemploGravaBanco extends StatefulWidget {
  const ExemploGravaBanco({super.key});

  @override
  State<ExemploGravaBanco> createState() => _ExemploGravaBancoState();
}

class _ExemploGravaBancoState extends State<ExemploGravaBanco> {
  late Database database;
  List<Objeto> objetos = [];

  final objetoController = TextEditingController();
  final descricaoController = TextEditingController();
  final imagemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();

    database = await openDatabase(
      join(dbPath, 'agenda_v2.db'), // Garanta que o nome do DB seja o mesmo ou mude para um novo
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE objetos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            objeto TEXT,
            descricao TEXT,
            imagem TEXT
          )
        ''');
      },
    );
    carregarObjetos();
  }

  Future<void> carregarObjetos() async {
    final List<Map<String, dynamic>> maps = await database.query('objetos');

    setState(() {
      objetos = List.generate(maps.length, (i) {
        return Objeto.fromMap(maps[i]);
      });
    });
  }

  Future<void> inserirObjeto(Objeto objeto) async {
    await database.insert('objetos', objeto.toMap());
    carregarObjetos();
  }

  Future<void> atualizarObjeto(Objeto objeto) async {
    await database.update(
      'objetos',
      objeto.toMap(),
      where: 'id = ?',
      whereArgs: [objeto.id],
    );
    carregarObjetos();
  }

  Future<void> excluirObjeto(int id) async {
    await database.delete('objetos', where: 'id = ?', whereArgs: [id]);
    carregarObjetos();
  }

  void _mostrarFormulario(BuildContext context, {Objeto? objeto}) {
    // Esta função será adaptada ou removida, pois a tela de cadastro
    // será uma tela separada, e não um bottom sheet.
    // Por enquanto, mantenha-a aqui.

    if (objeto != null) {
      objetoController.text = objeto.objeto;
      descricaoController.text = objeto.descricao;
      imagemController.text = objeto.imagem ?? '';
    } else {
      objetoController.clear();
      descricaoController.clear();
      imagemController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: objetoController,
              decoration: const InputDecoration(labelText: 'Objeto'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: imagemController,
              decoration: const InputDecoration(labelText: 'URL da Imagem (opcional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final objetoNome = objetoController.text.trim();
                final descricao = descricaoController.text.trim();
                final imagem = imagemController.text.trim().isNotEmpty ? imagemController.text.trim() : null;

                if (objetoNome.isEmpty || descricao.isEmpty) return;

                if (objeto != null) {
                  atualizarObjeto(
                    Objeto(id: objeto.id, objeto: objetoNome, descricao: descricao, imagem: imagem),
                  );
                } else {
                  inserirObjeto(Objeto(objeto: objetoNome, descricao: descricao, imagem: imagem));
                }
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ESTE MÉTODO BUILD SERÁ REMOVIDO COMPLETAMENTE
    // e sua lógica de UI será distribuída nas novas telas.
    // Por enquanto, apenas retorne um Container vazio ou com um Placeholder.
    return Container();
  }
}
