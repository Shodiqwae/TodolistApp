import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todolist_app/page/Home.dart';
import 'package:http/http.dart' as http;
import 'package:todolist_app/page/Register.dart';
import 'package:todolist_app/service/AuthService.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Authservice authservice = Authservice();
  final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
  }

  void _login() async { 
    final response = await authservice.login(
      emailController.text,
      passwordController.text,
    );

    if (response['status']) {
      // Simpan token ke shared preferences jika perlu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => 
        // ProfileScreen(token: response['data']['token'])
        HomePage(
          // token: response['data']['token'], 
          )
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response['message']}')),
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
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/LogoTodo.png',
                  width: 70,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Column(
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "Sign in to your\n",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: "inter-Extrabold",
                                fontSize: 30),
                          ),
                          TextSpan(
                            text: "Account",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: "inter-Extrabold",
                                fontSize: 30),
                          ),
                        ]))
                      ],
                    ))
              ],
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "Enter your email and password to log in",
                      style: TextStyle(
                          color: const Color.fromRGBO(108, 114, 120, 1)),
                    ))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              hintText: "Gmail",
                              hintStyle: TextStyle(
                                  color: const Color.fromARGB(255, 104, 104, 104),
                                  fontSize: 16),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                  borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 201, 201, 201),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 53, 53, 53)))),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: const Color.fromARGB(255, 119, 119, 119),
                                  fontSize: 16),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                  borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 201, 201, 201),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 53, 53, 53)))),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 6,),
                Row(
                  children: [
                   const SizedBox(width: 22,),
                    Text("Don't have an account?  ", style: TextStyle(color: const Color.fromARGB(255, 150, 150, 150),fontSize: 14,),),
                    GestureDetector(
                      onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                      },
                      child: Text("Sign Up", style: TextStyle(color: Colors.blue, fontSize: 14,decoration: TextDecoration.underline, decorationColor: Colors.blue),))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
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
                          color: Color.fromRGBO(0, 152, 255,1), 
                          elevation: 3,
                          borderRadius: BorderRadius.circular(17),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(17),
                            onTap: () {
                              _login();
                            },
                            child: Center(
                          
                              child: Text(
                                "Log in",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: "Mont-Bold"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
