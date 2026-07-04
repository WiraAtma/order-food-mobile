enum CategoryType {
  all,
  food,
  drink,
  desert,
  other;

  String get label {
    switch (this) {
      case CategoryType.all:
        return "Semua";
      case CategoryType.food:
        return "Makanan";
      case CategoryType.drink:
        return "Minuman";
      case CategoryType.desert:
        return "Dessert";
      case CategoryType.other:
        return "Lainnya";
    }
  }

  // if null not send to api (all category)
  String? get apiValue => this == CategoryType.all ? null : name;
}