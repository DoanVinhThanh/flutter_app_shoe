import 'package:flutter/material.dart';
import 'package:flutter_/widget/rounded_container.dart';

class SingleAddress extends StatelessWidget {
  final String? name;
  final String? phone;
  final String? number;
  final String? street;
  final String? ward;
  final String? district;
  final String? city;
  final bool? status;
  final bool selectedAddress;

  const SingleAddress({
    super.key,
    this.selectedAddress = false,
    this.name,
    this.phone,
    this.number,
    this.street,
    this.ward,
    this.district,
    this.city,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      showBorder: true,
      backgroundColor:
          selectedAddress ? Colors.blue.withOpacity(0.5) : Colors.transparent,
      borderColor: Colors.blue,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
              selectedAddress ? Icons.check : null,
              color: null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Họ và Tên: $name",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text("Số điện thoại: $phone",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text("Số nhà: $number , Đường: $street , Phường: $ward ,  Quận: $district , Thành phố: $city",
                  softWrap: true,
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

