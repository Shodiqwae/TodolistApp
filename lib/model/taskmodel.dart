class Task {
  final int id;
  final String name;
  final String categoryName;
  final String priority;
  final String createdAt;
  final String categoryColor;  // Menambahkan warna kategori

  Task({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.priority,
    required this.createdAt,
    required this.categoryColor,  // Menambahkan warna kategori di konstruktor
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['nama'] ?? '',
      categoryName: json['category'] != null ? json['category']['name'] ?? '' : '',
      categoryColor: json['category'] != null ? json['category']['color'] ?? '' : '',  // Mengambil warna kategori
      priority: json['priority'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
