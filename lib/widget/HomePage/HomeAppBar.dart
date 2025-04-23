import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeAppbar extends StatefulWidget {
  final String token;

  const HomeAppbar({super.key, required this.token});

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  late String _token;
  String userName = '';

  String today = DateFormat('EEEE').format(DateTime.now()); // e.g., Monday
  String fullDate =
      DateFormat('d MMMM y').format(DateTime.now()); // e.g., 21 April 2025
  double completionPercent = 0.0;
  double todayPercent = 0.0;

  Future<void> fetchUserName() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/api/user"),
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userName = data['nama'];
      });
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<void> fetchCompletionPercent() async {
    final response = await http
        .get(Uri.parse("http://10.0.2.2:8000/api/board-completion-percentage"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        completionPercent = (data['percentage'] / 100).clamp(0.0, 1.0);
      });
    } else {
      throw Exception('Failed to load percent data');
    }
  }

  Future<void> fetchTodayTaskPercent() async {
    final response = await http
        .get(Uri.parse("http://10.0.2.2:8000/api/today-task-completion"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        todayPercent = (data['percentage'] / 100).clamp(0.0, 1.0);
      });
    } else {
      throw Exception('Failed to load today task percent');
    }
  }

  @override
  void initState() {
    super.initState();
    _token = widget.token; // <-- pindahkan ini ke atas dulu
    fetchUserName();
    fetchCompletionPercent();
    fetchTodayTaskPercent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      decoration: BoxDecoration(
        gradient: SweepGradient(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 3.15 * 2, // 360 derajat
          stops: [0.55, 0.50],
          colors: [
            Color(0xFF0118D8), // warna kedua
            Color(0xFF1B56FD), // warna pertama
          ],
        ),
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
                    SizedBox(
                      height: 30,
                    ),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                        text: "$today\n",
                        style: TextStyle(
                          fontFamily: "Mont-Bold",
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: fullDate,
                        style: TextStyle(
                          fontFamily: "Mont-Bold",
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ]))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text("Welcome",
                        style: TextStyle(
                            fontFamily: "Mont-Bold",
                            fontSize: 16,
                            color: Colors.white)),
                    Text(
                      userName.isNotEmpty ? userName : "Loading...",
                      style: TextStyle(
                        fontFamily: "Mont-Bold",
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(right: 20, top: 30),
                  child: Column(
                    children: [
                      CircleAvatar(),
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                height: 165,
                width: 180,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(202, 225, 255, 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Today's Task Complete",
                              style: TextStyle(
                                  color: Color.fromRGBO(13, 71, 161, 1),
                                  fontFamily: "Mont-SemiBold",
                                  fontSize: 12),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: CircularPercentIndicator(
                            radius: 54.0,
                            lineWidth: 10.0,
                            percent: todayPercent,
                            center: Text(
                              "${(todayPercent * 100).toStringAsFixed(0)}%",
                              style: TextStyle(
                                fontFamily: "Mont-SemiBold",
                                color: Color.fromRGBO(13, 71, 161, 1),
                              ),
                            ),
                            progressColor: Color.fromRGBO(13, 71, 161, 1),
                            backgroundColor: Colors.grey.shade300,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                height: 165,
                width: 180,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(243, 229, 245, 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Total Task Complete",
                              style: TextStyle(
                                  color: Color.fromRGBO(74, 20, 140, 1),
                                  fontFamily: "Mont-SemiBold",
                                  fontSize: 12),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: CircularPercentIndicator(
                            radius: 54.0,
                            lineWidth: 10.0,
                            percent: completionPercent,
                            center: Text(
                                "${(completionPercent * 100).toStringAsFixed(0)}%",
                                style: TextStyle(
                                    fontFamily: "Mont-SemiBold",
                                    color: Color.fromRGBO(74, 20, 140, 1))),
                            progressColor: Color.fromRGBO(74, 20, 140, 1),
                            backgroundColor: Colors.grey.shade300,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
