import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/request/customer_login_post_req.dart';
import 'package:flutter_application_1/model/response/customer_login_post_res.dart';
import 'package:flutter_application_1/page/register.dart';
import 'package:flutter_application_1/page/showtrip.dart' hide Configuration;
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  String url = '';
  final TextEditingController phoneCtl = TextEditingController();
  final TextEditingController passwordCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: login,
              child: Image.asset("assets/images/logo.png", height: 300),
            ),
            const SizedBox(height: 16),
            const Text("หมายเลขโทรศัพท์", style: TextStyle(fontSize: 16)),
            TextField(
              controller: phoneCtl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text("รหัสผ่าน", style: TextStyle(fontSize: 16)),
            TextField(
              controller: passwordCtl,
              obscureText: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: register,
                  child: const Text('ลงทะเบียนใหม่'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text('เข้าสู่ระบบ'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void login() async {
    setState(() {
      text = '';
    });

    if (phoneCtl.text.isEmpty || passwordCtl.text.isEmpty) {
      setState(() {
        text = "กรุณากรอกหมายเลขโทรศัพท์และรหัสผ่าน";
      });
      return;
    }

    final req = CustomerLoginPostRequest(
      phone: phoneCtl.text,
      password: passwordCtl.text,
    );

    try {
      final response = await http.post(
        Uri.parse("$url/customers/login"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: customerLoginPostRequestToJson(req),
      );

      if (response.statusCode == 200) {
        final res = customerLoginPostResponseFromJson(response.body);
        log("Login success: ${res.customer.fullname}");

        // ส่ง userId ไปหน้า ShowTripPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ShowTripPage(userId: res.customer.idx),
          ),
        );
      } else {
        setState(() {
          text = "Login failed: ${response.statusCode}";
        });
      }
    } catch (error) {
      log('Error $error');
      setState(() {
        text = "เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์";
      });
    }
  }
}
