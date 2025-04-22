class Status {
  final int id;
  final String name;
  final String color;

  Status({required this.id, required this.name, required this.color});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      name: json['name'],
      color: json['color'],
    );
  }
}
