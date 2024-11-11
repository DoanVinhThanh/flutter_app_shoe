// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/users_sqlite.dart';
import 'package:flutter_/screens/admin/home_page_admin.dart';
import 'package:flutter_/screens/authentication/sign_in_screen.dart';
import 'package:flutter_/screens/user/address_screen.dart';
import 'package:flutter_/widget/textfield.dart';
import 'package:flutter_/widget/titleListCustom.dart';
import 'package:flutter_/widget/title_container.dart';



import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;

  const ProfileScreen({
    super.key,
    required this.userEmail,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formkey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final TextEditingController datePickerController = TextEditingController();

  Users? user;
  final db = DatabaseHelper();

  DateTime? _selectedDate;
  // Hàm để mở DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930, 1, 1),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        datePickerController.text =
            '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    
    _loadUserData();
  }

  _loadUserData() async {
    var userData = await db.getUser(widget.userEmail);
    setState(() {
      user = userData;
    });
  }

  final scaffoldKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  String imagePath = 'assets/cat.png'; // Đường dẫn ảnh mặc định
  bool isChangeSubmitted1 = false;
  bool isChangeSubmitted2 = false;
  bool isChangeSubmitted3 = false;

  // Hàm để chọn ảnh từ thư viện hoặc máy ảnh
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path; // Cập nhật đường dẫn ảnh
      });

      // Update avatar in database
      await db.updateAvatar(widget.userEmail, imagePath);
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 340,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade800,
                  Colors.blue.shade400,
                ]),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(65),
                  bottomRight: Radius.circular(65),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Tài khoản",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Stack(
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        user?.usrAvarta?.isNotEmpty == true
                                            ? FileImage(File(user!.usrAvarta!))
                                            : const AssetImage('assets/cat.png')
                                                as ImageProvider,
                                  ),
                                ),
                                Positioned(
                                  top: 100,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.8),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: _pickImage,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Safely access user properties using null-aware operators
                            Text(
                              user?.usrFullname ?? 'Đang tải...',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user?.usrEmail ?? 'Đang tải...',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    const TitleContainer(title: "Thông tin cá nhân"),
                    Stack(
                      children: [
                        TextFieldInput(
                          controller: fullNameController,
                          hint: user?.usrFullname ?? 'Đang tải...',
                          icon: Icons.person,
                          isPassword: false,
                          isEdit: isChangeSubmitted1,
                        ),
                        Positioned(
                          top: 10,
                          right: 0,
                          child: IconButton(
                              onPressed: () async {
                                if (!isChangeSubmitted1) {
                                  setState(() {
                                    isChangeSubmitted1 = true;
                                  });
                                } else {
                                  int result = await db.updateNameUser(
                                    widget.userEmail,
                                    fullNameController.text,
                                  );

                                  if (result > 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Thông tin cá nhân đã được cập nhật!')),
                                    );
                                    _loadUserData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Cập nhật thất bại!')),
                                    );
                                  }

                                  setState(() {
                                    isChangeSubmitted1 = false;
                                  });
                                }
                              },
                              icon: const Icon(Icons.edit)),
                        ),
                      ],
                    ),
                    Stack(children: [
                      TextFieldInput(
                        controller: phoneNumberController,
                        hint: user?.usrPhonenumber ?? 'Đang tải...',
                        icon: Icons.phone,
                        isPassword: false,
                        isEdit: isChangeSubmitted2,
                      ),
                      Positioned(
                        top: 10,
                        right: 0,
                        child: IconButton(
                            onPressed: () async {
                              if (!isChangeSubmitted2) {
                                setState(() {
                                  isChangeSubmitted2 = true;
                                });
                              } else {
                                int result = await db.updatePhoneUser(
                                  widget.userEmail,
                                  phoneNumberController.text,
                                );

                                if (result > 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Thông tin cá nhân đã được cập nhật!')),
                                  );
                                  _loadUserData();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Cập nhật thất bại!')),
                                  );
                                }

                                setState(() {
                                  isChangeSubmitted2 = false;
                                });
                              }
                            },
                            icon: const Icon(Icons.edit)),
                      ),
                    ]),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: datePickerController,
                            enabled: isChangeSubmitted3,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: const Icon(Icons.calendar_month),
                              hintText: user?.usrDate ?? 'Đang tải...',
                              hintStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: IconButton(
                                padding: const EdgeInsets.only(right: 40),
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () {
                                  _selectDate(context);
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 0,
                          child: IconButton(
                              onPressed: () async {
                                if (!isChangeSubmitted3) {
                                  setState(() {
                                    isChangeSubmitted3 = true;
                                  });
                                } else {
                                  int result = await db.updatePhoneUser(
                                    widget.userEmail,
                                    phoneNumberController.text,
                                  );

                                  if (result > 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Thông tin cá nhân đã được cập nhật!')),
                                    );
                                    _loadUserData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Cập nhật thất bại!')),
                                    );
                                  }

                                  setState(() {
                                    isChangeSubmitted3 = false;
                                  });
                                }
                              },
                              icon: const Icon(Icons.edit)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TitleContainer(title: "Thông tin đơn hàng"),
                  const SizedBox(height: 20),
                   TitleListCustom(
                    title: 'Địa Chỉ',
                    content: 'Thiết lập địa chỉ giao hàng',
                    icon: Icons.location_city,
                    page: UserAddressScreen(userEmail: widget.userEmail,),
                  ),
                  const SizedBox(height: 20),

                   TitleListCustom(
                    title: 'Trang admin',
                    content: 'Trang admin',
                    icon: Icons.document_scanner_outlined,
                    page: AdminScreen(userEmail: widget.userEmail,),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Đăng xuất",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
