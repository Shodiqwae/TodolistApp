class Explanation {
  final int id;
  final String name;
  final String? deskripsi;
  final int projectId;

  Explanation({
    required this.id,
    required this.name,
    this.deskripsi,
    required this.projectId,
  });

  factory Explanation.fromJson(Map<String, dynamic> json) {
    return Explanation(
      id: json['id'],
      name: json['name'],
      deskripsi: json['deskripsi'],
      projectId: json['project_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'deskripsi': deskripsi,
      'project_id': projectId,
    };
  }
}
