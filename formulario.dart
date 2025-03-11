import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Exemplo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemplo de Formulário'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: UserForm(),
        ),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _nameController = TextEditingController();

  bool estudarValue = false;
  bool dormirValue = false;
  bool comerValue = false;
  bool trabalharValue = false;

  String? escolhaValue = 'Churrasco';

  void _submitData() {
    String userName = _nameController.text;

    debugPrint('Nome do usuário: $userName');
    debugPrint('Estudar        : $estudarValue');
    debugPrint('Dormir         : $dormirValue');
    debugPrint('Comer          : $comerValue');
    debugPrint('Trabalhar      : $trabalharValue');
    debugPrint('Escolha        : $escolhaValue');
  }

  @override
  Widget build (BuildContext context) {
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        const Text('Nome(Remover)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Digite seu nome',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 50),

        const Text('Sobrenome: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Digite seu sobrenome',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 50),

        const Text('Atividades:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox (height: 10),
        Row (
          children: <Widget>[
            Checkbox(
              value: estudarValue,
              onChanged: (bool? value) {
                setState(() {
                  estudarValue = value!;
                });
              },
            ),
            const Text('Estudar'),
          ],     
        ),
        Row (
          children: <Widget>[
            Checkbox(
              value: dormirValue,
              onChanged: (bool? value) {
                setState(() {
                  dormirValue = value!;
                });
              },
            ),
            const Text('Dormir'),
          ],     
        ),
        Row (
          children: <Widget>[
            Checkbox(
              value: comerValue,
              onChanged: (bool? value) {
                setState(() {
                  comerValue = value!;
                });
              },
            ),
            const Text('Comer'),
          ],     
        ),
        Row (
          children: <Widget>[
            Checkbox(
              value: trabalharValue,
              onChanged: (bool? value) {
                setState(() {
                  trabalharValue = value!;
                });
              },
            ),
            const Text('Trabalhar'),
          ],     
        ),
        const SizedBox(height: 50),


        const Text('Escolha:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox (height: 10),
        Row (
          children: <Widget>[
            Radio<String>(
              value: 'Churrasco',
              groupValue: escolhaValue,
              onChanged: (String? value) {
                setState(() {
                  escolhaValue = value;
                });
              },
            ),
            const Text('Churrasco'),
          ],     
        ),
        Row (
          children: <Widget>[
            Radio<String>(
              value: 'Cama',
              groupValue: escolhaValue,
              onChanged: (String? value) {
                setState(() {
                  escolhaValue = value;
                });
              },
            ),
            const Text('Cama'),
          ],     
        ),
        Row (
          children: <Widget>[
            Radio<String>(
              value: 'Cinema',
              groupValue: escolhaValue,
              onChanged: (String? value) {
                setState(() {
                  escolhaValue = value;
                });
              },
            ),
            const Text('Cinema'),
          ],     
        ),
        const SizedBox(height: 50),

         const Text('Idade:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox (height: 10),
        Row (
          children: <Widget>[
            Radio<String>(
              value: 'Menos de 18 anos',
              groupValue: escolhaValue,
              onChanged: (String? value) {
                setState(() {
                  escolhaValue = value;
                });
              },
            ),
            const Text('Menos de 18 anos'),
          ],     
        ),
        Row (
          children: <Widget>[
            Radio<String>(
              value: 'De 18 à 30 anos',
              groupValue: escolhaValue,
              onChanged: (String? value) {
                setState(() {
                  escolhaValue = value;
                });
              },
            ),
            const Text('De 18 a 30 anos'),
          ],     
        ),
        Row (
          children: <Widget>[
            Radio<String>(
              value: 'Acima de 30 anos',
              groupValue: escolhaValue,
              onChanged: (String? value) {
                setState(() {
                  escolhaValue = value;
                });
              },
            ),
            const Text('Acima de 30 anos'),
          ],     
        ),
        const SizedBox(height: 50),

        Center(
          child: ElevatedButton(
            onPressed: _submitData,
            child: const Text('Enviar'),
            ),
        ),

      ],
    );
  }
}