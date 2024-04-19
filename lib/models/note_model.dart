class Note {
  final int? id;
  final String title;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? categoryId;

  const Note({
    this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
  });

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'description': description,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'category_id': categoryId,
    };
  }
}
