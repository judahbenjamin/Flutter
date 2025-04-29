import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App de Imagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaDeImagensScreen(),
    );
  }
}

class ListaDeImagensScreen extends StatefulWidget {
  @override
  _ListaDeImagensScreenState createState() => _ListaDeImagensScreenState();
}

class _ListaDeImagensScreenState extends State<ListaDeImagensScreen> {
  List<Uint8List?> _selectedImageBytes = [];
  List<String> _selectedImageNames = [];
  List<Uint8List?> _storedImageBytes = [];
  List<String> _storedImageNames = [];
  final int _maxFileSizeMB = 5; // Define o tamanho máximo do arquivo em MB

  Future<void> _selectImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      List<PlatformFile> files = result.files;
      List<Uint8List?> newImageBytes = [];
      List<String> newImageNames = [];
      bool hasDuplicates = false;

      // Verificação de nomes duplicados e tamanho dos arquivos
      for (PlatformFile file in files) {
        if (_selectedImageNames.contains(file.name) || _storedImageNames.contains(file.name)) {
          hasDuplicates = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: O arquivo "${file.name}" já foi selecionado ou armazenado.')),
          );
        } else if (file.size > _maxFileSizeMB * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: O arquivo "${file.name}" excede o tamanho máximo de ${_maxFileSizeMB}MB.')),
          );
        } else {
          newImageBytes.add(file.bytes);
          newImageNames.add(file.name);
        }
      }

      if (!hasDuplicates && newImageNames.isNotEmpty) {
        setState(() {
          _selectedImageBytes.addAll(newImageBytes);
          _selectedImageNames.addAll(newImageNames);
          print('Bytes das imagens selecionadas: $_selectedImageBytes');
          print('Nomes das imagens selecionadas: $_selectedImageNames');
        });
      }
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  void _gravarImagens() {
    if (_selectedImageNames.isNotEmpty && _selectedImageBytes.isNotEmpty) {
      setState(() {
        _storedImageBytes.addAll(_selectedImageBytes);
        _storedImageNames.addAll(_selectedImageNames);
        _selectedImageBytes.clear();
        _selectedImageNames.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_storedImageNames.length} imagens foram armazenadas.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhuma imagem selecionada para gravar.')),
      );
    }
  }

  Widget _buildImageSelectionArea() {
    if (_selectedImageNames.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Imagens selecionadas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _selectedImageNames.map((name) => Chip(label: Text(name))).toList(),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: _selectImages,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.arrow_right),
              SizedBox(width: 8.0),
              Text('Seleciona arquivo para envio'),
            ],
          ),
        ),
      );
    }
  }

  void _mostrarImagem(BuildContext context, Uint8List? imageBytes, String imageName) {
    if (imageBytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExibeImagemScreen(imageBytes: imageBytes, imageName: imageName),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar a imagem.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu App de Imagens'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: _storedImageNames.isEmpty
                  ? Center(
                      child: Text('Nenhuma imagem armazenada ainda.'),
                    )
                  : ListView.builder(
                      itemCount: _storedImageNames.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _mostrarImagem(context, _storedImageBytes[index], _storedImageNames[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${index + 1}. ${_storedImageNames[index]}'),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildImageSelectionArea(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _gravarImagens,
                child: Text('GRAVAR'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExibeImagemScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final String imageName;

  ExibeImagemScreen({required this.imageBytes, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagem Selecionada'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(imageBytes),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                imageName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('VOLTAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
