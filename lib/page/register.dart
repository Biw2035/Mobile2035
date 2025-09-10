import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'customer_regis_post.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullnameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();

  String text = '';

  void register() async {
    CustomerRegisPost req = CustomerRegisPost(
      fullname: fullnameCtl.text,
      phone: phoneCtl.text,
      email: emailCtl.text,
      image: "profile.png", // placeholder
      password: passwordCtl.text,
    );

    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.136:3000/customers"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: customerRegisPostToJson(req),
      );

      if (response.statusCode == 200) {
        setState(() {
          text = "ลงทะเบียนสำเร็จ ✅";
        });
      } else {
        setState(() {
          text = "ลงทะเบียนไม่สำเร็จ ❌ : ${response.statusCode}";
        });
      }
    } catch (error) {
      setState(() {
        text = "เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: fullnameCtl,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: phoneCtl,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: emailCtl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordCtl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: register, child: const Text("ลงทะเบียน")),
            const SizedBox(height: 16),
            Text(text, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
