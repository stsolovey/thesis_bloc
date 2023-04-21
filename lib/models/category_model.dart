class Category {
  final String id;
  final String name;
  final int weight;

  Category({
    required this.id,
    required this.name,
    required this.weight,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'],
      name: json['category_name'],
      weight: json['category_weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': id,
      'category_name': name,
      'category_weight': weight,
    };
  }
}
