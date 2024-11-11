import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/address_sqlite.dart';




// BillingAddress.dart

class BillingAddress extends StatelessWidget {
  final String? userEmail;

  const BillingAddress({super.key, this.userEmail});

  // Fetch the selected address from the database
  Future<Address?> fetchSelectedAddress() async {
    final db = DatabaseHelper();
    return await db.getSelectedAddressByEmail(userEmail!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Address?>(
      future: fetchSelectedAddress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Text('Không có địa chỉ được chọn');
        }

        final address = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Text(address.addressNameUser ?? ""),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Text(address.addressPhone ?? ""),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_city,
                  color: Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Số nhà: ${address.addressNumber},Đường: ${address.addressStreet},Phường: ${address.addressWard},Quận: ${address.addressDistrict},Thành Phố: ${address.addressCity}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

