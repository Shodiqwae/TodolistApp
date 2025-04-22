import 'package:flutter/material.dart';

class BtnGoogle extends StatelessWidget {
  const BtnGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color.fromARGB(47, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(30)
                    
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("images/LogGoogle.png", width: 30,),
                        SizedBox(width: 10,),
                        Text("Sign Up With Google",style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: "WS-Medium",fontSize: 17))
                      ],
                    ),
                  ),
                ),
              )
              
            ],
           );
  }
}