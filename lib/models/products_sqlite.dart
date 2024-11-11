class Product {
  final int? productId;
  final String? productImage;
  final String? productName;
  final String? productDescription;
  final String? productPrice;
  final String? productSize;
  final String? productColor;
  final String? productImages;


  Product({
    this.productId,
    this.productImage,
    this.productName,
    this.productDescription,
    this.productPrice,
    this.productSize,
    this.productColor,
    this.productImages,

  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    productId: json["productId"],
    productImage: json["productImage"],
    productName: json["productName"],
    productDescription: json["productDescription"],
    productPrice: json["productPrice"],
    productSize: json["productSize"],
    productColor: json["productColor"],
    productImages: json["productImages"],

  );

  Map<String, dynamic> toMap() => {
    "productId": productId,
    "productImage": productImage,
    "productName": productName,
    "productDescription": productDescription,
    "productPrice": productPrice,
    "productSize": productSize,
    "productColor": productColor,
    "productImages": productImages,
  };
}
