import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/menu/bottom_navigation_bar.dart'; // Trang chính sau khi đăng nhập
import 'package:flutter_/models/users_sqlite.dart';
import 'package:flutter_/screens/authentication/forgot_password_screen.dart';
import 'package:flutter_/screens/authentication/sign_up_screen.dart';
import 'package:flutter_/screens/admin/home_page_admin.dart'; // Trang quản trị
import 'package:flutter_/widget/text_link.dart';
import 'package:flutter_/widget/textfield.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailLogin = TextEditingController();
  final passwordLogin = TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool isVisible = false;
  bool isLoginTrue = false;

  // SQLite
  final db = DatabaseHelper();

  // login method
  login() async {
    if (emailLogin.text.isEmpty || passwordLogin.text.isEmpty) {
      setState(() {
        isLoginTrue = true;
      });
      return;
    }

    // Kiểm tra nếu email là 'admin' và mật khẩu là '1'
    if (emailLogin.text == 'admin' && passwordLogin.text == '1') {
      // Chuyển hướng đến trang admin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  AdminScreen(userEmail: emailLogin.text,),
        ),
      );
      return; // Dừng lại ở đây nếu là admin
    }

    // Nếu không phải admin, kiểm tra thông tin đăng nhập từ SQLite
    var res = await db.login(
      Users(usrEmail: emailLogin.text, usrPassword: passwordLogin.text),
    );

    if (res == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userEmail: emailLogin.text),
        ),
      );
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
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
                      "Đăng nhập",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Chào mừng bạn đến với MyClothes",
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
                      children: [
                        const SizedBox(height: 20),
                        isLoginTrue
                            ? const Text(
                                "Email hoặc Mật khẩu không đúng !",
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
                                  controller: emailLogin,
                                  hint: "Email",
                                  icon: Icons.email,
                                  isPassword: false,
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
                                    controller: passwordLogin,
                                    obscureText: !isVisible,
                                    decoration: InputDecoration(
                                      hintText: "Mật khẩu",
                                      icon: const Icon(Icons.password),
                                      hintStyle: const TextStyle(color: Colors.grey),
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const TextLink(
                          text: "Quên mật khẩu ?",
                          widget: ForgotPasswordScreen(),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
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
                                  login();
                                }
                              },
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const TextLink(
                          text: "Bạn chưa có tài khoản ?",
                          widget: SignUpScreen(),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Hoặc",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                  border: Border.all(width: 0.5, color: Colors.blue),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 27,
                                      width: 27,
                                      child: Image.asset("assets/facebook.png"),
                                    ),
                                    const SizedBox(width: 20),
                                    const Text(
                                      "Facebook",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                  border: Border.all(width: 0.5),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: Image.asset("assets/google.png"),
                                    ),
                                    const SizedBox(width: 20),
                                    const Text(
                                      "Google",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}