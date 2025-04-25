import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
  List<String> _selectedImagePaths = [];

  Future<void> _selectImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Filtra para mostrar apenas arquivos de imagem
      allowMultiple: true, // Permite selecionar múltiplos arquivos
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedImagePaths = result.paths!.whereType<String>().toList();
        // Aqui você pode adicionar a lógica para exibir os nomes dos arquivos
        // ou as próprias imagens na área superior, se desejar.
        print('Caminhos das imagens selecionadas: $_selectedImagePaths');
      });
    } else {
      // O usuário cancelou a seleção ou não escolheu nenhum arquivo.
      print('Nenhuma imagem selecionada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de imagens armazenadas'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              // Aqui você exibirá as imagens selecionadas ou os nomes dos arquivos
              // Por enquanto, deixamos vazio.
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _selectImages, // Chama a função ao tocar
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.arrow_right),
                      SizedBox(width: 8.0),
                      Text('Seleciona arquivo para envio'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aqui você implementará a lógica para gravar/armazenar as imagens
                  if (_selectedImagePaths.isNotEmpty) {
                    print('Imagens prontas para serem gravadas: $_selectedImagePaths');
                    // Implemente a lógica de armazenamento aqui.
                  } else {
                    print('Nenhuma imagem selecionada para gravar.');
                  }
                },
                child: Text('GRAVAR'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}