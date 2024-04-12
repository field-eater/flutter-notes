class Note {
  final int id;
  final String title;
  final String description;
  final DateTime date;

  const Note({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
