class CategoryModel {
  final int? id;
  final String title;

  CategoryModel({
    this.id,
    required this.title,
  });

// CategoryModel.(Map<String, dynamic> map) {
//     id:
//     map['id'];
//     title:
//     map['title'];
//   }

  Map<String, Object?> toMap() {
    return {
      'title': title,
    };
  }
}
