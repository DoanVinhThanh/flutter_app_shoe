class OrderDetail {
  final int? orderDetailId;
  final int orderId;  
  final String productName;
  final int productPrice;
  final int quantity;
  final int total;  

  OrderDetail({
    this.orderDetailId,
    required this.orderId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.total,  
  });

  
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'total': total,  
    };
  }

  
  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      orderDetailId: map['orderDetailId'],
      orderId: map['orderId'],
      productName: map['productName'],
      productPrice: map['productPrice'],
      quantity: map['quantity'],
      total: map['total'],  
    );
  }
}
