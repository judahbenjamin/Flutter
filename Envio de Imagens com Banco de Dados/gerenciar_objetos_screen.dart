import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importe o gerenciador de BD
import 'Objeto.dart'; // Importe o modelo Objeto
import 'cadastro_objeto_screen.dart'; // Para navegar para a tela de edição
import 'detalhes_objeto_screen.dart'; // Para navegar para a tela de detalhes
import 'dart:io'; // Para o tipo File, usado para exibir imagens locais

class GerenciarObjetosScreen extends StatefulWidget {
  const GerenciarObjetosScreen({super.key});

  @override
  State<GerenciarObjetosScreen> createState() => _GerenciarObjetosScreenState();
}

class _GerenciarObjetosScreenState extends State<GerenciarObjetosScreen> {
  final dbHelper = DatabaseHelper(); // Instância do DatabaseHelper

  @override
  void initState() {
    super.initState();
    _carregarObjetos(); // Carrega os objetos quando a tela é iniciada
  }

  // Função para carregar objetos (atualiza o estado da tela)
  Future<void> _carregarObjetos() async {
    await dbHelper.carregarObjetos(); // Chama a função do helper
    setState(() {
      // O setState é chamado aqui para reconstruir a UI com a lista atualizada
      // dbHelper.objetos já foi atualizada pela chamada acima
    });
  }

  // Função para excluir objeto
  Future<void> _excluirObjeto(int id) async {
    await dbHelper.excluirObjeto(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Objeto excluído com sucesso!')),
    );
    _carregarObjetos(); // Recarrega a lista após a exclusão
  }

  // Função para navegar para a tela de edição
  void _navegarParaEdicao(BuildContext context, Objeto objeto) {
    // Preenche os controllers do DatabaseHelper com os dados do objeto a ser editado
    dbHelper.objetoController.text = objeto.objeto;
    dbHelper.descricaoController.text = objeto.descricao;
    dbHelper.imagemController.text = objeto.imagem ?? '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroObjetoScreen(
          objetoController: dbHelper.objetoController,
          descricaoController: dbHelper.descricaoController,
          imagemController: dbHelper.imagemController,
          inserirObjeto: dbHelper.inserirObjeto,
          atualizarObjeto: dbHelper.atualizarObjeto,
          carregarObjetos: _carregarObjetos, // Passa a função local para recarregar esta lista
          objetoParaEditar: objeto, // Passa o objeto para edição
        ),
      ),
    ).then((_) {
      // Quando a tela de edição volta, recarrega a lista para refletir as mudanças
      _carregarObjetos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Coisas!'), // Título da AppBar
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: dbHelper.objetos.isEmpty
                ? const Center(child: Text('Nenhum objeto cadastrado.'))
                : ListView.builder(
                    itemCount: dbHelper.objetos.length,
                    itemBuilder: (context, index) {
                      final objeto = dbHelper.objetos[index];

                      return Card( // Usando Card para um visual mais agradável
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        elevation: 3,
                        child: ListTile(
                          leading: GestureDetector( // Use GestureDetector para adicionar o onTap ao CircleAvatar
                            onTap: () {
                              // Verifica se há uma imagem para exibir antes de navegar
                              if (objeto.imagem != null && objeto.imagem!.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalhesObjetoScreen(objeto: objeto),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Nenhuma imagem para visualizar.')),
                                );
                              }
                            },
                            child: CircleAvatar( // SEU CircleAvatar EXISTENTE
                              backgroundColor: Colors.grey[200], // Um fundo leve para o avatar
                              child: (objeto.imagem != null && objeto.imagem!.isNotEmpty)
                                  ? ClipOval( // Garante que a imagem seja circular
                                      child: (objeto.imagem!.startsWith('/') || objeto.imagem!.startsWith('file://'))
                                          ? Image.file(
                                              File(objeto.imagem!),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.broken_image, size: 24.0, color: Colors.red),
                                            )
                                          : (objeto.imagem!.startsWith('http://') || objeto.imagem!.startsWith('https://'))
                                              ? Image.network(
                                                  objeto.imagem!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  errorBuilder: (context, error, stackTrace) =>
                                                      const Icon(Icons.error_outline, size: 24.0, color: Colors.red),
                                                )
                                              : const Icon(Icons.inventory, size: 24.0), // Fallback para caminhos inválidos
                                    )
                                  : const Icon(Icons.inventory, size: 24.0), // Ícone padrão se não houver imagem
                            ),
                          ),
                          title: Text(objeto.objeto),
                          subtitle: Text(objeto.descricao),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Botão de Editar
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _navegarParaEdicao(context, objeto),
                              ),
                              // Botão de Excluir
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _excluirObjeto(objeto.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volta para a HomeScreen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size.fromHeight(50), // Faz o botão ter largura total
              ),
              child: const Text('VOLTAR', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
