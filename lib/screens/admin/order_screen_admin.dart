import 'package:flutter/material.dart';
import 'package:flutter_/screens/admin/order_list_item_admin.dart';

class OrderScreenAdmin extends StatelessWidget {

  const OrderScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Quản lý đơn hàng"),
        ),
        body: const Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'Chờ xác nhận',),
                Tab(text: 'Đang giao'),
                Tab(text: 'Đã giao'),
                Tab(text: 'Đã hủy'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: OrderListItemsAdmin(
                      status: "Chờ xác nhận",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: OrderListItemsAdmin(
                      status: "Đang giao",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: OrderListItemsAdmin(
                      status: "Đã giao",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: OrderListItemsAdmin(
                      status: "Đã hủy",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
