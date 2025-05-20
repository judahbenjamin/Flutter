import 'package:flutter/material.dart';
// Remova estes imports se não forem usados diretamente aqui:
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
import 'Objeto.dart'; // Importe o modelo Objeto

// Definimos um tipo para a função de callback, para que a tela possa chamar as funções de BD do helper.
typedef FutureDatabaseMethod = Future<void> Function(Objeto objeto);
typedef FutureLoadMethod = Future<void> Function();

class CadastroObjetoScreen extends StatefulWidget {
  // FINALMENTE, removemos o parâmetro 'database' daqui!
  // final Database database; // <-- REMOVA ESTA LINHA!

  final TextEditingController objetoController;
  final TextEditingController descricaoController;
  final TextEditingController imagemController;
  final FutureDatabaseMethod inserirObjeto;
  final FutureDatabaseMethod atualizarObjeto;
  final FutureLoadMethod carregarObjetos;
  final Objeto? objetoParaEditar;

  const CadastroObjetoScreen({
    super.key,
    // REMOVA -> required this.database,
    required this.objetoController,
    required this.descricaoController,
    required this.imagemController,
    required this.inserirObjeto,
    required this.atualizarObjeto,
    required this.carregarObjetos,
    this.objetoParaEditar,
  });

  @override
  State<CadastroObjetoScreen> createState() => _CadastroObjetoScreenState();
}

class _CadastroObjetoScreenState extends State<CadastroObjetoScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.objetoParaEditar != null) {
      widget.objetoController.text = widget.objetoParaEditar!.objeto;
      widget.descricaoController.text = widget.objetoParaEditar!.descricao;
      widget.imagemController.text = widget.objetoParaEditar!.imagem ?? '';
    } else {
      widget.objetoController.clear();
      widget.descricaoController.clear();
      widget.imagemController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Coisas!'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: widget.objetoController,
              decoration: const InputDecoration(
                labelText: 'Objeto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: widget.descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: widget.imagemController,
              decoration: const InputDecoration(
                labelText: 'Imagem (URL ou caminho)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('VOLTAR', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final objetoNome = widget.objetoController.text.trim();
                      final descricao = widget.descricaoController.text.trim();
                      final imagem = widget.imagemController.text.trim().isNotEmpty
                          ? widget.imagemController.text.trim()
                          : null;

                      if (objetoNome.isEmpty || descricao.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Objeto e Descrição são obrigatórios!')),
                        );
                        return;
                      }

                      if (widget.objetoParaEditar != null) {
                        await widget.atualizarObjeto(
                          Objeto(
                            id: widget.objetoParaEditar!.id,
                            objeto: objetoNome,
                            descricao: descricao,
                            imagem: imagem,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Objeto atualizado com sucesso!')),
                        );
                      } else {
                        await widget.inserirObjeto(
                          Objeto(objeto: objetoNome, descricao: descricao, imagem: imagem),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Objeto cadastrado com sucesso!')),
                        );
                      }

                      widget.objetoController.clear();
                      widget.descricaoController.clear();
                      widget.imagemController.clear();
                      Navigator.pop(context);
                      await widget.carregarObjetos(); // Recarrega os objetos após salvar/atualizar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('OK', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}