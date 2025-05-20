class Objeto {
  final int? id; // O 'id' continua sendo opcional para quando o objeto ainda não foi salvo no BD
  final String objeto; // Nome do objeto (ex: "Livro", "Ferramenta")
  final String descricao; // Descrição do objeto
  final String? imagem; // Caminho ou URL da imagem (opcional, pode ser nulo)

  Objeto({this.id, required this.objeto, required this.descricao, this.imagem});

  // Converte um objeto Objeto em um Map, útil para inserir/atualizar no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'objeto': objeto,
      'descricao': descricao,
      'imagem': imagem,
    };
  }

  // Cria um objeto Objeto a partir de um Map, útil para ler do banco de dados
  factory Objeto.fromMap(Map<String, dynamic> map) {
    return Objeto(
      id: map['id'],
      objeto: map['objeto'],
      descricao: map['descricao'],
      imagem: map['imagem'],
    );
  }

  // Método toString para facilitar a depuração (opcional, mas útil)
  @override
  String toString() {
    return 'Objeto{id: $id, objeto: $objeto, descricao: $descricao, imagem: $imagem}';
  }
}