import 'package:flutter/material.dart';
import 'dart:io'; // Para o tipo File
import 'Objeto.dart'; // Importe o modelo Objeto

class DetalhesObjetoScreen extends StatelessWidget {
  final Objeto objeto; // A tela receberá um objeto para exibir

  const DetalhesObjetoScreen({super.key, required this.objeto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Objeto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Permite rolagem se o conteúdo for muito grande
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha o texto à esquerda
          children: [
            // Exibição da Imagem
            Center( // Centraliza a imagem
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% da largura da tela
                height: MediaQuery.of(context).size.height * 0.4, // 40% da altura da tela
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200], // Cor de fundo para placeholder
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: objeto.imagem != null && objeto.imagem!.isNotEmpty
                      ? (
                          // Verifica se é um arquivo local
                          objeto.imagem!.startsWith('/') ||
                          objeto.imagem!.startsWith('file://')
                        )
                          ? Image.file(
                              File(objeto.imagem!),
                              fit: BoxFit.contain, // Ajusta a imagem dentro do container
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                            )
                          : ( // Tenta carregar como NetworkImage se for URL
                              objeto.imagem!.startsWith('http://') ||
                              objeto.imagem!.startsWith('https://')
                            )
                              ? Image.network(
                                  objeto.imagem!,
                                  fit: BoxFit.contain, // Ajusta a imagem dentro do container
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, size: 80, color: Colors.red),
                                )
                              : const Icon(Icons.image_not_supported, size: 80, color: Colors.grey) // Fallback final
                      : const Center(child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey)), // Sem imagem
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Detalhes do Objeto
            Text(
              'Objeto:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              objeto.objeto,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 30, thickness: 1), // Separador

            Text(
              'Descrição:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              objeto.descricao,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 30, thickness: 1), // Separador

            // Botão Voltar (opcional, já que a AppBar tem um)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Volta para a tela anterior
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'VOLTAR',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}