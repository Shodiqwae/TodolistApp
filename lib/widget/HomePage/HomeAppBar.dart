import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color.fromRGBO(19, 86, 148, 1), Color.fromRGBO(0, 102, 204, 1)])
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                        Text.rich(
                          TextSpan(children: [
                         TextSpan(text:"Monday\n", style: TextStyle(fontFamily: "Mont-Bold", fontSize: 14, color: Colors.white),),
                      TextSpan(text: "21 April 2025", style: TextStyle(fontFamily: "Mont-Bold", fontSize: 12, color: Colors.white)),
                      
                          ])
                        )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 30),
                      child: Column(
                        children: [
                        SizedBox(height: 25,),
                          Text("Welcome", style: TextStyle(fontFamily: "Mont-Bold", fontSize: 16, color: Colors.white)),
                          Text("John", style: TextStyle(fontFamily: "Mont-Bold", fontSize: 16, color: Colors.white))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20,top: 30),
                      child: Column(
                        children: [
                          CircleAvatar(),
                        ],
                      ))
                  ],
                ),
                // Row(
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(left: 15),
                //       height: 150,
                //       width: 180,
                //       decoration: BoxDecoration(
                //       color: Color.fromRGBO(202, 225, 255, 1),
                //         borderRadius: BorderRadius.circular(20)
                //       ),
                //       child: Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Container(
                //                 margin: EdgeInsets.only(top: 10),
                //                 child: Text("Today's Task Complete",style: TextStyle(color: Color.fromRGBO(13, 71, 161, 1),fontFamily: "Mont-SemiBold", fontSize: 11),))
                //             ],
                //           ),
                //           Row(
                //             children: [

                //             ],
                //           )
                //         ],
                //       ),
                //     ),
                //     Container(
                //       margin: EdgeInsets.only(left: 20),
                //       height: 150,
                //       width: 180,
                //       decoration: BoxDecoration(
                //       color: Color.fromRGBO(243, 229, 245, 1),
                //         borderRadius: BorderRadius.circular(20)
                //       ),
                //       child: Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Container(
                //                 margin: EdgeInsets.only(top: 10),
                //                 child: Text("Total Task Complete",style: TextStyle(color: Color.fromRGBO(74, 20, 140, 1),fontFamily: "Mont-SemiBold", fontSize: 12),))
                //             ],
                //           ),
                //           Row(
                //             children: [

                //             ],
                //           )
                //         ],
                //       ),
                //     ),
                //   ],
                // )
              ],
              
            ),
          );
  }
}