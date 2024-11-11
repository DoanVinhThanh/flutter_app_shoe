class Category {
  final int? categoryId;
  final String? categoryName;
  final String? categoryImage;

  Category({
    this.categoryId,
    this.categoryName,
    this.categoryImage,
  });

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        categoryImage: json["categoryImage"],
      );

  Map<String, dynamic> toMap() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "categoryImage": categoryImage,
      };
}
