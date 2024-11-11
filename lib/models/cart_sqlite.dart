class Cart {
    final int? cartId;
    final String? cartImage;
    final String? cartName;
    final String? cartQuantity;
    final String? cartPrice;
    final String? cartSize;
    final String? cartColor;
    final String? cartEmailUser;

    Cart({
         this.cartId,
         this.cartImage,
         this.cartName,
         this.cartQuantity,
         this.cartPrice,
         this.cartSize,
         this.cartColor,
         this.cartEmailUser,
    });

    factory Cart.fromMap(Map<String, dynamic> json) => Cart(
        cartId: json["cartId"],
        cartImage: json["cartImage"],
        cartName: json["cartName"],
        cartQuantity: json["cartQuantity"],
        cartPrice: json["cartPrice"],
        cartSize: json["cartSize"],
        cartColor: json["cartColor"],
        cartEmailUser: json["cartEmailUser"],
    );

    Map<String, dynamic> toMap() => {
        "cartId": cartId,
        "cartImage": cartImage,
        "cartName": cartName,
        "cartQuantity": cartQuantity,
        "cartPrice": cartPrice,
        "cartSize": cartSize,
        "cartColor": cartColor,
        "cartEmailUser": cartEmailUser,
    };
}
