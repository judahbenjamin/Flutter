import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Para selecionar imagens
import 'dart:io'; // Para o tipo File
import 'Objeto.dart'; // Importe o modelo Objeto

// Definimos um tipo para a função de callback, para que a tela possa chamar as funções de BD do helper.
typedef FutureDatabaseMethod = Future<void> Function(Objeto objeto);
typedef FutureLoadMethod = Future<void> Function();

class CadastroObjetoScreen extends StatefulWidget {
  final TextEditingController objetoController;
  final TextEditingController descricaoController;
  final TextEditingController imagemController;
  final FutureDatabaseMethod inserirObjeto;
  final FutureDatabaseMethod atualizarObjeto;
  final FutureLoadMethod carregarObjetos;
  final Objeto? objetoParaEditar;

  const CadastroObjetoScreen({
    super.key,
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
  String? _selectedImagePath; // Variável para armazenar o caminho da imagem selecionada
  final ImagePicker _picker = ImagePicker(); // Instância do ImagePicker

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
        widget.imagemController.text = pickedFile.path; // Atualiza o controller com o caminho
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.objetoParaEditar != null) {
      widget.objetoController.text = widget.objetoParaEditar!.objeto;
      widget.descricaoController.text = widget.objetoParaEditar!.descricao;
      // Se houver uma imagem, preenche o _selectedImagePath
      if (widget.objetoParaEditar!.imagem != null &&
          widget.objetoParaEditar!.imagem!.isNotEmpty) {
        _selectedImagePath = widget.objetoParaEditar!.imagem;
      } else {
        _selectedImagePath = null; // Garante que esteja nulo se não houver imagem
      }
      widget.imagemController.text = _selectedImagePath ?? ''; // Atualiza o controller também
    } else {
      widget.objetoController.clear();
      widget.descricaoController.clear();
      widget.imagemController.clear();
      _selectedImagePath = null; // Limpa para novo cadastro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Coisas!'), centerTitle: true),
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

            // Prévia da Imagem e Botões de Seleção
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Imagem:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // Exibe a imagem selecionada ou um placeholder
                Container(
                  width: 150, // Largura fixa para a prévia
                  height: 150, // Altura fixa para a prévia
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImagePath != null && _selectedImagePath!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (
                              // Verifica se é um arquivo local
                              _selectedImagePath!.startsWith('/') ||
                              _selectedImagePath!.startsWith('file://')
                          )
                              ? Image.file(
                                  File(_selectedImagePath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                )
                              : ( // Tenta carregar como NetworkImage se for URL
                                  _selectedImagePath!.startsWith('http://') ||
                                  _selectedImagePath!.startsWith('https://')
                              )
                                  ? Image.network(
                                      _selectedImagePath!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, size: 50, color: Colors.red),
                                    )
                                  : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey), // Fallback final
                        )
                      : const Center(
                          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Galeria'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Câmera'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30), // Espaçamento após os botões de imagem

            // O TextField da imagem original foi removido/comentado conforme discutido,
            // pois a prioridade é a seleção. Se quiser digitar URL, ele precisa voltar
            // e a lógica de _selectedImagePath precisaria ser mais robusta.

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
                      // Agora, a imagem vem de _selectedImagePath
                      final imagem = _selectedImagePath != null && _selectedImagePath!.isNotEmpty
                          ? _selectedImagePath
                          : null;

                      if (objetoNome.isEmpty || descricao.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Objeto e Descrição são obrigatórios!',
                            ),
                          ),
                        );
                        return;
                      }

                      if (widget.objetoParaEditar != null) {
                        await widget.atualizarObjeto(
                          Objeto(
                            id: widget.objetoParaEditar!.id,
                            objeto: objetoNome,
                            descricao: descricao,
                            imagem: imagem, // Usa o _selectedImagePath
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Objeto atualizado com sucesso!'),
                          ),
                        );
                      } else {
                        await widget.inserirObjeto(
                          Objeto(
                            objeto: objetoNome,
                            descricao: descricao,
                            imagem: imagem, // Usa o _selectedImagePath
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Objeto cadastrado com sucesso!'),
                          ),
                        );
                      }

                      // Limpa os campos e a imagem selecionada após salvar/atualizar
                      widget.objetoController.clear();
                      widget.descricaoController.clear();
                      widget.imagemController.clear(); // O controller também é limpo
                      setState(() {
                        _selectedImagePath = null; // Limpa a prévia da imagem
                      });

                      Navigator.pop(context);
                      await widget
                          .carregarObjetos(); // Recarrega os objetos após salvar/atualizar
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
