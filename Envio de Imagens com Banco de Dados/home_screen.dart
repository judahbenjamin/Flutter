import 'package:flutter/material.dart';
import 'cadastro_objeto_screen.dart'; // Importe a tela de cadastro
import 'database_helper.dart'; // Importe o gerenciador de BD

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancia o DatabaseHelper para acessar as funções de BD e controllers
    final dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Coisas!'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Botão "CADASTRAR"
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Limpa os controllers antes de abrir a tela para um novo cadastro
                    dbHelper.objetoController.clear();
                    dbHelper.descricaoController.clear();
                    dbHelper.imagemController.clear();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CadastroObjetoScreen(
                              objetoController: dbHelper.objetoController,
                              descricaoController: dbHelper.descricaoController,
                              imagemController: dbHelper.imagemController,
                              inserirObjeto: dbHelper.inserirObjeto,
                              atualizarObjeto: dbHelper.atualizarObjeto,
                              carregarObjetos:
                                  dbHelper
                                      .carregarObjetos, // Passa a função de recarregar
                              objetoParaEditar: null, // É um novo cadastro
                            ),
                      ),
                    );
                  },
                  child: const Text(
                    'CADASTRAR',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botão "GERENCIAR"
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Navegar para Tela de Gerenciamento (próximo passo!)',
                        ),
                      ),
                    );
                    // AQUI SERÁ A NAVEGAÇÃO PARA GerenciarObjetosScreen
                  },
                  child: const Text(
                    'GERENCIAR',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
