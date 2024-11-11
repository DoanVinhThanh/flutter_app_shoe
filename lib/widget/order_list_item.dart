import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/order_sqlite.dart';
import 'package:flutter_/screens/user/order_detail_screen.dart';
import 'package:flutter_/widget/rounded_container.dart';


import 'package:get/get.dart';

class OrderListItems extends StatefulWidget {
  final String userEmail;
  final String status;

  const OrderListItems(
      {super.key, required this.userEmail, required this.status});

  @override
  State<OrderListItems> createState() => _OrderListItemsState();
}

class _OrderListItemsState extends State<OrderListItems> {
    late Future<List<Order>> ordersFuture;

  Future<List<Order>> fetchOrdersByStatus() async {
    // Fetch orders with the specified status
    return await DatabaseHelper().getOrdersByStatus(widget.userEmail, widget.status);
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    // Update the order status in the database
    await DatabaseHelper().updateOrderStatus(orderId, newStatus);
    // After updating, fetch the orders again
    setState(() {
      ordersFuture = fetchOrdersByStatus();  // Reload the orders
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: fetchOrdersByStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Lỗi khi tải đơn hàng'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có đơn hàng'));
        } 

        final orders = snapshot.data!;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => OrderDetailScreen(
                    orderId: order.orderId!)); // Navigate to details screen
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedContainer(
                  radius: 20,
                  padding: const EdgeInsets.all(16),
                  showBorder: true,
                  backgroundColor: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.tag),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Đơn hàng #${order.orderId}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text("Trạng thái: ${order.status}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text("Ngày: ${order.orderDate}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.attach_money),
                          const SizedBox(width: 10),
                          Text("Tổng tiền: ${order.totalAmount}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      
                      if(order.status == "Chờ xác nhận" )...[
                            ElevatedButton(
                              onPressed: () async {
                                await updateOrderStatus(order.orderId!, 'Đã hủy');
                                Get.snackbar('Thông báo', 'Đơn hàng đã bị hủy');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child:  const Text('Hủy',style: TextStyle(color: Colors.white),),
                            ),
                          ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
