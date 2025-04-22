class TitleBoard {
  final int? id;
  final String name;

  TitleBoard({
    this.id,
    required this.name,
  });

  factory TitleBoard.fromJson(Map<String, dynamic> json) {
    return TitleBoard(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}