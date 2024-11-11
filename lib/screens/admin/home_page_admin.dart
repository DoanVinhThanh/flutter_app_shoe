
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/users_sqlite.dart';
import 'package:flutter_/screens/admin/category_admin.dart';
import 'package:flutter_/screens/admin/order_screen_admin.dart';
import 'package:flutter_/screens/admin/product_admin.dart';
import 'package:flutter_/screens/authentication/sign_in_screen.dart';
import 'package:flutter_/widget/titleListCustom.dart';


import 'package:image_picker/image_picker.dart';

class AdminScreen extends StatefulWidget {
  final String userEmail;

  const AdminScreen({
    super.key,
    required this.userEmail,
  });

  @override
  State<AdminScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<AdminScreen> {
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
                    "Trang admin",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TitleListCustom(
                    title: 'Quản lý đơn hàng',
                    content: 'Xem và duyệt các đơn hàng',
                    icon: Icons.document_scanner,
                    page: OrderScreenAdmin(),
                  ),
                  const SizedBox(height: 20),
                  const TitleListCustom(
                    title: 'Banner',
                    content: 'Thêm, Sửa, Xóa Banner',
                    icon: Icons.image,
                    page: ProductAdminScreen(),
                  ),
                  const SizedBox(height: 20),
                   const TitleListCustom(
                    title: 'Danh mục',
                    content: 'Thêm, Sửa, Xóa Danh mục',
                    icon: Icons.list,
                    page: CategoryAdminScreen(),
                  ),
                  const SizedBox(height: 20),
                  const TitleListCustom(
                    title: 'Sản phẩm',
                    content: 'Thêm, Sửa , Xóa sản phẩm',
                    icon: Icons.production_quantity_limits,
                    page: ProductAdminScreen(),
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
