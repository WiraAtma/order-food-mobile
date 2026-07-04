import 'package:order_food_mobile/core/utilities/json_parser.dart';

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
      id: JsonParser.toIntOrNull(json['id']),
      name: JsonParser.toStringValue(json['name']),
      description: JsonParser.toStringValue(json['description']),
      price: JsonParser.toInt(json['price']),
      image: JsonParser.toStringOrNull(json['image']),
      category: JsonParser.toStringValue(json['category']),
      createdAt: JsonParser.toStringOrNull(json['created_at']),
      updatedAt: JsonParser.toStringOrNull(json['updated_at']),
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