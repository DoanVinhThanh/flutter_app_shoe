import 'package:flutter/material.dart';
import 'package:flutter_/screens/user/cart_screen.dart';
import 'package:flutter_/widget/app_bar.dart';
import 'package:flutter_/widget/order_list_item.dart';
import 'package:get/get.dart';



class OrderScreen extends StatelessWidget {
  final String userEmail;

  const OrderScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        body: Column(
          children: [
             AppBarWidget(
              isButtonBack: false,
              title: "Đơn hàng",
              icon: Icons.add,
              isIcon: true,
              isQuantity: false,
              onIconPressed: () => Get.to(CartScreen(userEmail: userEmail)),
            ),
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'Chờ xác nhận'),
                Tab(text: 'Đang giao'),
                Tab(text: 'Đã giao'),
                Tab(text: 'Đã hủy'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OrderListItems(
                      userEmail: userEmail,
                      status: 'Chờ xác nhận',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OrderListItems(
                      userEmail: userEmail,
                      status: 'Đang giao',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OrderListItems(
                      userEmail: userEmail,
                      status: 'Đã giao',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OrderListItems(
                      userEmail: userEmail,
                      status: 'Đã hủy',
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
