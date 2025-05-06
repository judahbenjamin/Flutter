import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html; // Import para web


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
  final int _maxFileSizeMB = 5;
  String? _saveDirectory;

  @override
  void initState() {
    super.initState();
    _carregarImagensSalvas();
  }

  Future<void> _carregarImagensSalvas() async {
    if (_saveDirectory == null) {
      _saveDirectory = (await getApplicationDocumentsDirectory()).path;
    }
    if (kIsWeb) {
      setState(() {
        _storedImageBytes = List.from(_selectedImageBytes);
        _storedImageNames = List.from(_selectedImageNames);
      });
    } else {
      final directory = Directory(_saveDirectory!);
      if (directory.existsSync()) {
        List<FileSystemEntity> files = directory.listSync();
        for (FileSystemEntity file in files) {
          if (file is File) {
            try {
              String extension = path.extension(file.path).toLowerCase();
              if (extension == '.jpg' ||
                  extension == '.png' ||
                  extension == '.jpeg') {
                Uint8List bytes = await file.readAsBytes();
                _storedImageBytes.add(bytes);
                _storedImageNames.add(path.basename(file.path));
              }
            } catch (e) {
              print('Erro ao carregar arquivo: ${file.path} - $e');
            }
          }
        }
        setState(() {});
      }
    }
  }

  Future<void> _selecionarDiretorio() async {
    if (kIsWeb) {
      setState(() {
        _saveDirectory = 'arquivos_salvos';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Diretório de salvamento padrão definido para: arquivos_salvos')),
      );
      _carregarImagensSalvas();
    } else {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (status.isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Permissão de armazenamento necessária para selecionar o diretório.')),
          );
          return;
        }
      }

      try {
        String? directory = await FilePicker.platform.getDirectoryPath();
        print("Diretório selecionado: $directory");

        if (directory != null) {
          setState(() {
            _saveDirectory = directory;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Diretório de salvamento selecionado: $_saveDirectory')),
            );
          });
          _carregarImagensSalvas();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nenhum diretório de salvamento selecionado.')),
          );
        }
      } catch (e) {
        print("Erro ao selecionar diretório: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar diretório: $e')),
        );
      }
    }
  }

  Future<void> _selectImages() async {
    if (_saveDirectory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Por favor, selecione um diretório de salvamento primeiro.')),
      );
      return;
    }

    if (!kIsWeb) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (status.isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Permissão de armazenamento necessária para selecionar imagens.')),
          );
          return;
        }
      }
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        List<PlatformFile> files = result.files;
        List<Uint8List?> newImageBytes = [];
        List<String> newImageNames = [];
        bool hasDuplicates = false;

        for (PlatformFile file in files) {
          if (_selectedImageNames.contains(file.name) ||
              _storedImageNames.contains(file.name)) {
            hasDuplicates = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Erro: O arquivo "${file.name}" já foi selecionado ou armazenado.')),
            );
          } else if (file.size > _maxFileSizeMB * 1024 * 1024) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Erro: O arquivo "${file.name}" excede o tamanho máximo de ${_maxFileSizeMB}MB.')),
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
    } catch (e) {
      print("Erro ao selecionar imagens: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagens: $e')),
      );
    }
  }

  Future<void> _gravarImagens() async {
    if (_saveDirectory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Por favor, selecione um diretório de salvamento primeiro.')),
      );
      return;
    }

    if (!kIsWeb) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (status.isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Permissão de armazenamento necessária para salvar imagens.')),
          );
          return;
        }
      }
    }

    if (_selectedImageNames.isNotEmpty && _selectedImageBytes.isNotEmpty) {
      for (int i = 0; i < _selectedImageNames.length; i++) {
        String filePath = path.join(_saveDirectory!, _selectedImageNames[i]);
        try {
          if (kIsWeb) {
             // Usa a API do navegador para salvar o arquivo (download)
            final blob = html.Blob([_selectedImageBytes[i]], 'image/jpeg');
            final url = html.Url.createObjectUrlFromBlob(blob);
            final anchor = html.AnchorElement(href: url)
              ..setAttribute('download', _selectedImageNames[i])
              ..click();
            html.Url.revokeObjectUrl(url);
          } else {
            File file = File(filePath);
            await file.writeAsBytes(_selectedImageBytes[i]!);
            print('Imagem "${_selectedImageNames[i]}" salva em: $filePath');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erro ao salvar "${_selectedImageNames[i]}": $e')),
          );
          return;
        }
      }

      setState(() {
        _storedImageBytes.addAll(_selectedImageBytes);
        _storedImageNames.addAll(_selectedImageNames);
        _selectedImageBytes.clear();
        _selectedImageNames.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${_storedImageNames.length} imagens foram armazenadas e salvas no computador.')),
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
              children: _selectedImageNames
                  .map((name) => Chip(label: Text(name)))
                  .toList(),
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
              Text('Selecionar arquivo para envio'),
            ],
          ),
        ),
      );
    }
  }

  void _mostrarImagem(
      BuildContext context, Uint8List? imageBytes, String imageName) {
    if (imageBytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExibeImagemScreen(imageBytes: imageBytes, imageName: imageName),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar a imagem.')),
      );
    }
  }

  Future<Directory> getApplicationDocumentsDirectory() async {
    if (kIsWeb) {
      return Directory('arquivos_salvos');
    } else {
      return await getApplicationDocumentsDirectoryNative();
    }
  }

  Future<Directory> getApplicationDocumentsDirectoryNative() async{
    return Directory(await _getDefaultSaveDirectory());
  }

  Future<String> _getDefaultSaveDirectory() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Pictures/MeuAppImagens';
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else if (Platform.isWindows) {
      return '${Platform.environment['USERPROFILE']}\\Pictures\\MeuAppImagens';
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Meu App de Imagens'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _selecionarDiretorio,
              child: Text('Selecionar Diretório de Salvamento'),
            ),
          ),
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
                            _mostrarImagem(context, _storedImageBytes[index],
                                _storedImageNames[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text('${index + 1}. ${_storedImageNames[index]}'),
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
                child: Text('GRAVAR E SALVAR'),
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

