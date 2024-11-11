import 'package:flutter/material.dart';
import 'package:flutter_/SQLite/database_helper.dart';
import 'package:flutter_/screens/authentication/sign_in_screen.dart';
import 'package:flutter_/widget/text_link.dart';
import 'package:flutter_/widget/textfield.dart';



class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
    final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isEmailSubmitted = false;
  //SQLite 
  final dbHelper = DatabaseHelper();

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
              const SizedBox(
                height: 80,
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Quên mật khẩu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        )),
                    Text("Vui lòng nhập email của bạn",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Form(
                  key:  formkey,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 130, 195, 249),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                TextFieldInput(
                                  controller: emailController,
                                  hint: "Email",
                                  icon: Icons.email,
                                  isPassword: false,
                                  isEdit: !isEmailSubmitted,
                                ),
                                const SizedBox(height: 20),
                                if (isEmailSubmitted) ...[
                                  TextFieldInput(
                                    controller: passwordController,
                                    hint: "Mật khẩu mới",
                                    icon: Icons.lock,
                                    isPassword: true,
                                  ),
                                  const SizedBox(height: 20),
                                  TextFieldInput(
                                    controller: confirmPasswordController,
                                    hint: "Xác nhận mật khẩu",
                                    icon: Icons.lock,
                                    isPassword: true,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
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
                                onPressed: () async {
                                  //SQLite
                                  if (!isEmailSubmitted) {
                                    //Check if the email exists
                                    bool emailExists = await dbHelper.forgot(emailController.text, '');
                                    if (emailExists) {
                                      // Show password fields
                                      setState(() {
                                        isEmailSubmitted = true;
                                      });
                                    } else {
                                      // Show error message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Email không tồn tại"),
                                        ),
                                      );
                                    }
                                  } else {
                                    // Handle password reset (validate passwords, etc.)
                                    final newPassword = passwordController.text;
                                    final confirmPassword = confirmPasswordController.text;
                                    if (newPassword == confirmPassword) {
                                      // Proceed with password reset
                                      bool isResetSuccessful = await dbHelper.forgot(emailController.text, newPassword);
                                      if (isResetSuccessful) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Đặt lại mật khẩu thành công"),
                                          ),
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Đặt lại mật khẩu thất bại"),
                                          ),
                                        );
                                      }
                                    } else {
                                      // Show error if passwords do not match
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Mật khẩu không khớp"),
                                        ),
                                      );
                                    }
                                  }

                                },
                                child: Text(
                                  isEmailSubmitted ? "Đặt lại mật khẩu" : "Gửi yêu cầu",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const TextLink(text: "Quay lại đăng nhập", widget: SignInScreen()),
                        ],
                      ),
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
