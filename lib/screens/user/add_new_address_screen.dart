// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/address_sqlite.dart';
import 'package:flutter_/widget/textfield.dart';



class AddNewAddressScreen extends StatefulWidget {
  final String email;
  const AddNewAddressScreen({super.key, required this.email});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  final numberController = TextEditingController();

  final streetController = TextEditingController();

  final wardController = TextEditingController();

  final districtController = TextEditingController();

  final cityController = TextEditingController();

  String? _name;

  String? _phone;

  String? _number;

  String? _street;

  String? _ward;

  String? _district;

  String? _city;

  @override
  Widget build(BuildContext context) {
    void submitForm() async {
  if (_formKey.currentState!.validate()) {
    _name = nameController.text;
    _phone = phoneController.text;
    _number = numberController.text;
    _street = streetController.text;
    _ward = wardController.text;
    _district = districtController.text;
    _city = cityController.text;

    final newAddress = Address(
      addressNameUser: _name,
      addressPhone: _phone,
      addressNumber: _number,
      addressStreet: _street,
      addressWard: _ward,
      addressDistrict: _district,
      addressCity: _city,
      addressStatus: false,
      addressEmailUser: widget.email,
    );

    try {
      await DatabaseHelper().insertAddress(newAddress);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address added: $_name')),
      );
      // Return to the previous screen and refresh the address list
      Navigator.pop(context, true); // Pass 'true' to indicate an address was added
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding address: $e')),
      );
    }
  }
}


    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new address"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFieldInput(
                  hint: "Họ Và Tên",
                  icon: Icons.person,
                  controller: nameController,
                  isPassword: false,
                  value1: _name,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldInput(
                  hint: "Số Điện Thoại",
                  icon: Icons.mobile_friendly,
                  controller: phoneController,
                  isPassword: false,
                  value1: _phone,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldInput(
                        hint: "Số nhà",
                        icon: Icons.numbers,
                        controller: numberController,
                        isPassword: false,
                        value1: _number,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFieldInput(
                        hint: "Đường",
                        icon: Icons.text_fields,
                        controller: streetController,
                        isPassword: false,
                        value1: _street,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldInput(
                        hint: "Phường",
                        icon: Icons.numbers,
                        controller: wardController,
                        isPassword: false,
                        value1: _ward,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFieldInput(
                        hint: "Quận",
                        icon: Icons.text_fields,
                        controller: districtController,
                        isPassword: false,
                        value1: _district,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                TextFieldInput(
                  hint: "Thành phố",
                  icon: Icons.location_city,
                  controller: cityController,
                  isPassword: false,
                  value1: _city,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
