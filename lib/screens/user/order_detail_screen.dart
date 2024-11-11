import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/order_detail_sqlite.dart';
import 'package:flutter_/widget/product_title_text.dart';
import 'package:flutter_/widget/rounded_container.dart';



class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  Future<List<OrderDetail>> fetchOrderDetails() async {
    return await DatabaseHelper().getOrderDetailsByOrderId(orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: FutureBuilder<List<OrderDetail>>(
        future: fetchOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading order details: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items in this order'));
          }

          final orderDetails = snapshot.data!;

        // Log the fetched data
        for (var detail in orderDetails) {
          print('Fetched productPrice: ${detail.productPrice}, quantity: ${detail.quantity}, total: ${detail.total}');
        }
          return ListView.builder(
            itemCount: orderDetails.length,
            itemBuilder: (context, index) {
              final detail = orderDetails[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RoundedContainer(
                      radius: 20,
                      padding: const EdgeInsets.all(16),
                      showBorder: true,
                      backgroundColor: Colors.white,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductTitleText(
                                  title: detail.productName,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 5),
                                Text("Price: ${detail.productPrice}"),
                                Text("Quantity: ${detail.quantity}"),
                                Text("Total: ${detail.total}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
