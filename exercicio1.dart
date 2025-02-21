import 'package:flutter/material.dart'; // Importa o pacote material.dart, que contém widgets e funcionalidades básicas do Flutter

void main() {
  runApp(MyApp()); // Executa o aplicativo MyApp
}

class MyApp extends StatelessWidget { // Define a classe MyApp, que representa o widget raiz do aplicativo
  @override
  Widget build(BuildContext context) { // Método build() que retorna o widget que será renderizado na tela
    return MaterialApp( // Widget MaterialApp, que configura o aplicativo com tema, rotas, etc.
      home: MyHomePage(), // Define a página inicial do aplicativo como MyHomePage
    );
  }
}

class MyHomePage extends StatelessWidget { // Define a classe MyHomePage, que representa a página inicial do aplicativo
  @override
  Widget build(BuildContext context) { // Método build() que retorna o widget que será renderizado na tela
    return Scaffold( // Widget Scaffold, que define a estrutura básica da tela com AppBar, body, etc.
      appBar: AppBar( // Widget AppBar, que define a barra superior da tela
        title: Text('Meu Aplicativo'), // Define o título da AppBar
      ),
      body: Center( // Widget Center, que centraliza o conteúdo da tela
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.blue,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.red,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.yellow,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.green,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.orange,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.orange,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.green,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.blue,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.red,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.yellow,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.yellow,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.red,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.orange,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.green,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.blue,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.orange,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.green,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.blue,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.red,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.yellow,
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.yellow,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.blue,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.orange,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.green,
                ),
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.red,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

