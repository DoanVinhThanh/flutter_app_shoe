import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/models/users_sqlite.dart';
import 'package:flutter_/screens/authentication/sign_in_screen.dart';
import 'package:flutter_/widget/text_link.dart';
import 'package:flutter_/widget/textfield.dart';
import 'package:http/http.dart' as http; // Thêm thư viện http
import 'dart:convert'; // Để sử dụng json.encode


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usrnameRegister = TextEditingController();
  final emailRegister = TextEditingController();
  final passwordRegister = TextEditingController();
  final rePasswordRegister = TextEditingController();
  final phoneNumberRegister = TextEditingController();
  final datePickerController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  bool isVisible = false;
  bool isVisible1 = false;
  bool isRegisterTrue = false;
  //SQLite
  // đăng ký
  signUp() async {
    final db = DatabaseHelper();
    db
        .signUp(Users(
      usrAvarta: "",
      usrFullname: usrnameRegister.text,
      usrEmail: emailRegister.text,
      usrPhonenumber: phoneNumberRegister.text,
      usrDate: datePickerController.text,
      usrPassword: passwordRegister.text,
    ))
        .whenComplete(() {
      Navigator.pop(context);
    });
  }

  //API
  // signUp() async {
  //   if (passwordRegister.text != rePasswordRegister.text) {
  //     setState(() {
  //       isRegisterTrue = true;
  //     });
  //     return;
  //   }

  //   final response = await http.post(
  //     Uri.parse('http://192.168.1.71:3000/api/users/register'), // Địa chỉ API
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'fullname': usrnameRegister.text,
  //       'email': emailRegister.text,
  //       'password': passwordRegister.text,
  //       'phoneNumber': phoneNumberRegister.text,
  //       'dateOfBirth': datePickerController.text,
  //       'imageProfile': "",
  //     }),
  //   );

  //   if (response.statusCode == 201) {
  //     // Đăng ký thành công
  //     Navigator.pop(context);
  //   } else {
  //     // Đăng ký không thành công
  //     print('Error: ${response.statusCode} - ${response.body}'); // In mã lỗi
  //     setState(() {
  //       isRegisterTrue = true;
  //     });
  //   }
  // }

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.blue.shade800,
                    Colors.blue.shade500,
                    Colors.blue.shade400,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Đăng ký",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Tạo tài khoản mới cho MyClothes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            isRegisterTrue
                                ? const Text(
                                    "Email hoặc Mật khẩu không đúng!",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 20),
                            Form(
                              key: formkey,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 130, 195, 249),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    TextFieldInput(
                                      hint: "Họ và Tên",
                                      icon: Icons.account_circle,
                                      controller: usrnameRegister,
                                      isPassword: false,
                                    ),
                                    TextFieldInput(
                                      hint: "Email",
                                      icon: Icons.email,
                                      controller: emailRegister,
                                      isPassword: false,
                                    ),
                                    TextFieldInput(
                                      hint: "Số điện thoại",
                                      icon: Icons.phone,
                                      controller: phoneNumberRegister,
                                      isPassword: false,
                                      isNumeric: true,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        controller: datePickerController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon:
                                              const Icon(Icons.calendar_month),
                                          hintText: "Ngày tháng năm sinh",
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.calendar_today),
                                            onPressed: () {
                                              _selectDate(context);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Vui lòng điền mật khẩu";
                                          }
                                          return null;
                                        },
                                        controller: passwordRegister,
                                        obscureText: !isVisible,
                                        decoration: InputDecoration(
                                          hintText: "Mật khẩu",
                                          icon: const Icon(Icons.password),
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isVisible = !isVisible;
                                              });
                                            },
                                            icon: Icon(
                                              isVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Vui lòng nhập lại mật khẩu";
                                          } else if (passwordRegister.text !=
                                              rePasswordRegister.text) {
                                            return "Mật khẩu không trùng khớp";
                                          }
                                          return null;
                                        },
                                        controller: rePasswordRegister,
                                        obscureText: !isVisible1,
                                        decoration: InputDecoration(
                                          hintText: "Nhập lại Mật khẩu",
                                          icon: const Icon(Icons.password),
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isVisible1 = !isVisible1;
                                              });
                                            },
                                            icon: Icon(
                                              isVisible1
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const TextLink(
                                text: "Bạn đã có tài khoản?",
                                widget: SignInScreen()),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: true,
                                    onChanged: (value) {},
                                    activeColor: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text("Tôi đồng ý với",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16)),
                                const SizedBox(width: 5),
                                const TextLink(
                                    text: "Chính sách", widget: SignInScreen()),
                                const SizedBox(width: 5),
                                const Text("và",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16)),
                                const SizedBox(width: 5),
                                const TextLink(
                                    text: "Điều khoản", widget: SignInScreen()),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade800,
                                    Colors.blue.shade500,
                                    Colors.blue.shade400,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    if (formkey.currentState!.validate()) {
                                      //SQLite
                                      //signUp();
                                      //API
                                      signUp();
                                    }
                                  },
                                  child: const Text(
                                    "Đăng ký",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
  