import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart'; // Para TextEditingController
import 'Objeto.dart'; // Importe o modelo Objeto

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database; // Mude para nullable

  // Controllers para uso nos formulários
  final objetoController = TextEditingController();
  final descricaoController = TextEditingController();
  final imagemController = TextEditingController();

  // Lista de objetos para gerenciar o estado
  List<Objeto> objetos = [];
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'agenda_v2.db'), // Garanta que o nome do DB seja o mesmo
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
  }

  // Funções de CRUD:
  Future<void> carregarObjetos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('objetos');

    objetos = List.generate(maps.length, (i) {
      return Objeto.fromMap(maps[i]);
    });
    // IMPORTANTE: Como DatabaseHelper não é um StatefulWidget,
    // ele não pode chamar setState(). As telas que usarem objetos
    // precisarão chamar setState() em seus próprios contextos.
  }

  Future<void> inserirObjeto(Objeto objeto) async {
    final db = await database;
    await db.insert('objetos', objeto.toMap());
    // Não chamaremos carregarObjetos aqui para evitar setState em helper
  }

  Future<void> atualizarObjeto(Objeto objeto) async {
    final db = await database;
    await db.update(
      'objetos',
      objeto.toMap(),
      where: 'id = ?',
      whereArgs: [objeto.id],
    );
    // Não chamaremos carregarObjetos aqui para evitar setState em helper
  }

  Future<void> excluirObjeto(int id) async {
    final db = await database;
    await db.delete('objetos', where: 'id = ?', whereArgs: [id]);
    // Não chamaremos carregarObjetos aqui para evitar setState em helper
  }
}
