class Menu {
  final int? id;
  final String name;
  final String description;
  final int price;
  final String? image;
  final String? createdAt;
  final String? updatedAt;
  final String category;

  Menu({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    this.createdAt,
    this.updatedAt,
    required this.category,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json["id"],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      category: json['category'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'image': image,
    'category': category,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
