import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/address_sqlite.dart';
import 'package:flutter_/screens/user/add_new_address_screen.dart';
import 'package:flutter_/widget/single_address.dart';


import 'package:get/get.dart';

class UserAddressScreen extends StatefulWidget {
  final String? userEmail;
  const UserAddressScreen({super.key, this.userEmail});

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  late Future<List<Address>> _addressesFuture;
  int? selectedAddressId; // To track the selected address

  @override
  void initState() {
    super.initState();
    _addressesFuture = _fetchAddress(); // Fetch addresses on init
  }

  Future<List<Address>> _fetchAddress() async {
    // Fetch addresses from database
    List<Address> addresses =
        await DatabaseHelper().getAddressesByEmail(widget.userEmail!);

    // Set the selected address based on the addressStatus from the database
    final selectedAddress = addresses.firstWhere(
        (address) => address.addressStatus == true,
        orElse: () => Address()); // Default to empty Address if not found
    if (selectedAddress.addressId != null) {
      selectedAddressId = selectedAddress.addressId;
    }

    return addresses;
  }

  // Handle address selection
  void _selectAddress(Address address) async {
    setState(() {
      selectedAddressId = address.addressId;
    });

    // Update the status in the database: set the selected address's status to true, others to false
    try {
      await DatabaseHelper().updateAddressStatus(address.addressId!, true);
      final addresses = await _fetchAddress(); // Refresh the address list
      for (var addr in addresses) {
        if (addr.addressId != address.addressId) {
          await DatabaseHelper().updateAddressStatus(addr.addressId!, false);
        }
      }
      // Reload the addresses after updating status
      setState(() {
        _addressesFuture = _fetchAddress(); // Update future to refresh data
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating address status: $e')),
      );
    }
  }

  // Show confirmation dialog before deleting the address
  Future<void> _showDeleteDialog(Address address) async {
    // Show dialog and wait for user response
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this address?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    // If the user confirmed the deletion, proceed with removing the address
    if (confirmed == true) {
      await _deleteAddress(address);
    } else {
      // If deletion was canceled, reload the address list
      setState(() {
        _addressesFuture = _fetchAddress(); // Reload the list after canceling
      });
    }
  }

  // Delete address method
  Future<void> _deleteAddress(Address address) async {
    try {
      await DatabaseHelper().deleteAddress(address.addressId!);
      // Reload address list after deletion
      setState(() {
        _addressesFuture = _fetchAddress(); // Refresh the address list after deletion
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting address: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Địa chỉ của tôi"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Wait for the result when returning from AddNewAddressScreen
          bool? addressAdded =
              await Get.to(() => AddNewAddressScreen(email: widget.userEmail!));
          if (addressAdded ?? false) {
            setState(() {
              _addressesFuture = _fetchAddress(); // Refresh the address list
            });
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<Address>>(
        future: _addressesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No addresses available.'));
          }

          final addresses = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: addresses.map((address) {
                return Dismissible(
                  key: Key(address.addressId.toString()), // Unique key for each item
                  direction: DismissDirection.endToStart, // Swipe left to right
                  background: Container(
                    color: Colors.red, // Background color when swiped
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    // Instead of immediately deleting, show the dialog
                    _showDeleteDialog(address);
                  },
                  child: GestureDetector(
                    onTap: () => _selectAddress(address), // When an address is tapped, set it as selected
                    child: SingleAddress(
                      selectedAddress: selectedAddressId == address.addressId,
                      name: address.addressNameUser,
                      phone: address.addressPhone,
                      number: address.addressNumber,
                      street: address.addressStreet,
                      ward: address.addressWard,
                      district: address.addressDistrict,
                      city: address.addressCity,
                      status: address.addressStatus,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
