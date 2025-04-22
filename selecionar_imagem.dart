import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(const CarregaImagem());
}

class CarregaImagem extends StatelessWidget {
  const CarregaImagem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enviar Imagem',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PaginaEnviaImagem(),
    );
  }
}

class PaginaEnviaImagem extends StatefulWidget {
  const PaginaEnviaImagem({super.key});

  @override
  createState() => StatusEnviandoImagem();
}

Future<void> gravaImagem(io.File? imagemMobile) async {
  if (imagemMobile == null) {
    return;
  }

  /* Um diretório interno do aplicativo */
  final diretorio = await getApplicationDocumentsDirectory();

  /* Diretório "imagens" dentro do diretório do aplicativo */
  final diretorioImagens = io.Directory(path.join(diretorio.path, 'imagens'));

  /* Cria a pasta se ela não tiver sido criada antes */
  if (!await diretorioImagens.exists()) {
    await diretorioImagens.create(recursive: true);
  }

  /* Caminho do novo arquivo */
  final nomeArquivo = path.basename(imagemMobile.path);
  final caminhoDestino = path.join(diretorioImagens.path, nomeArquivo);

  /* Copia a imagem */
  final novaImagem = await imagemMobile.copy(caminhoDestino);

  print("Imagem salva em: ${novaImagem.path}");
}

class StatusEnviandoImagem extends State<PaginaEnviaImagem> {
  Uint8List? _dadosImagemBrowser; /* Quando for navegadores */
  io.File? _dadosImagemMobile; /* Quando for celulares */
  String? _nomeImagem; /* Uso geral, vai guardar o nome da imagem */

  final _identificador = ImagePicker();

  Future<void> _selecionarImagem() async {
    final XFile? imagem =
        await _identificador.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      /* Todo arquivo tem nome, só grava o nome em uma variável */
      final nome = kIsWeb ? imagem.name : path.basename(imagem.path);
      setState(() {
        _nomeImagem = nome.toString();
      });

      if (kIsWeb) {
        /* Exectaa se estiver em um browser */
        final bytes = await imagem.readAsBytes();
        setState(() {
          _dadosImagemBrowser = bytes;
        });
      } else {
        /* Executa se for em um dispositivo móvel */
        setState(() {
          _dadosImagemMobile = io.File(imagem.path);
        });
        await gravaImagem(_dadosImagemMobile);
      }
    }
  }

  Widget _exibeImagem() {
    if (kIsWeb && _dadosImagemBrowser != null) {
      /* Se for browser */
      return Column(children: [
        Text(_nomeImagem ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Image.memory(
          _dadosImagemBrowser!,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ]);
    } else if (!kIsWeb && _dadosImagemMobile != null) {
      /* Se for browser */
      return Column(children: [
        Text(_nomeImagem ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Image.file(
          _dadosImagemMobile!,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ]);
    } else {
      /* Não tem imagem */
      return const Text('Nenhuma imagem selecionada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviar Imagem')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _exibeImagem(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selecionarImagem,
              child: const Text('Selecionar Imagem'),
            ),
          ],
        ),
      ),
    );
  }
}
