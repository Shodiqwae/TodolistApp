import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist_app/page/Login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    if (namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final url = Uri.parse("http://192.168.211.57:8000/api/register");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': namaController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'role': 'user'
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      final error = jsonDecode(response.body);
      String message = error['error'] ?? 'Registrasi gagal.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/LogoTodo.png',
                  width: 70,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "Create your\n",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "inter-Extrabold",
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: "Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "inter-Extrabold",
                      color: Colors.black,
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Masukkan data kamu untuk membuat akun",
                style: TextStyle(color: Color.fromRGBO(108, 114, 120, 1)),
              ),
            ),
            SizedBox(height: 30),
            inputField("Nama", namaController),
            SizedBox(height: 15),
            inputField("Gmail", emailController),
            SizedBox(height: 15),
            inputField("Password", passwordController, obscure: true),
            SizedBox(height: 6),
            Row(
              children: [
                SizedBox(width: 22),
                Text(
                  "Sudah punya akun? ",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Material(
                      color: Color.fromRGBO(0, 152, 255, 1),
                      elevation: 3,
                      borderRadius: BorderRadius.circular(17),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(17),
                        onTap: registerUser,
                        child: Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Mont-Bold",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget inputField(String hint, TextEditingController controller,
      {bool obscure = false}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 54,
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 201, 201, 201)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 53, 53, 53)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
