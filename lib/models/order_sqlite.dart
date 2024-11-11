class Order {
  final int? orderId;           
  final String userEmail;       
  final double? totalAmount;     
  final String? address;         
  final String? status;          
  final String? orderDate;       

  
  Order({
    this.orderId,               
    required this.userEmail,
     this.totalAmount,
     this.address,
    this.status = 'Chờ xác nhận', 
     this.orderDate,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'totalAmount': totalAmount,
      'address': address,
      'status': status,
      'orderDate': orderDate,
    };
  }

  
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],       
      userEmail: map['userEmail'],
      totalAmount: map['totalAmount'],
      address: map['address'],
      status: map['status'] ?? 'Chờ xác nhận', 
      orderDate: map['orderDate'],
    );
  }
}
