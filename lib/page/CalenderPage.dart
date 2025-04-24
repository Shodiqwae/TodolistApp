import 'dart:convert';
import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist_app/model/calenderevent.dart';
import 'package:todolist_app/page/HistoryPage.dart';
import 'package:todolist_app/page/Home.dart';
import 'package:todolist_app/page/Task.dart';

class CalendarPage extends StatefulWidget {
  final String token;
  const CalendarPage({super.key, required this.token});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
        late String _token;

    int _currentIndex = 3;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<CalendarEvent>> _events = {};

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _token = widget.token;
    fetchCalendarEvents();
  }

Future<void> fetchCalendarEvents() async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/calendar-events'),
    headers: {
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    Map<DateTime, List<CalendarEvent>> eventMap = {};

    for (var item in data) {
      final event = CalendarEvent.fromJson(item);
      final eventDate = DateTime.utc(event.date.year, event.date.month, event.date.day);
      eventMap.putIfAbsent(eventDate, () => []).add(event);
    }

    setState(() {
      _events = eventMap;
    });
  } else {
    print('Gagal mengambil data kalender: ${response.statusCode}');
  }
}


    void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(token: _token,)),
          );
        });
        break;
      case 1:
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TaskPage(
                      token: _token,
                    )),
          );
        });
        break;
      case 2:
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Historypage(
                      token: _token,
                    )),
          );
        });
        break;
        case 3:
        //  Future.delayed(Duration(milliseconds: 750), () {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Historypage(
        //               token: _token,
        //             )),
        //   );
        // });
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Tugas', style: TextStyle(color: Colors.white,fontFamily: "Mont-SemiBold"),),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TableCalendar<CalendarEvent>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
         
             Expanded(
              child: _buildEventList(),
            ),
       
        ],
      ),
                  bottomNavigationBar: BottomBarBubble(
    color: const Color.fromARGB(255, 255, 255, 255),
    backgroundColor: Color.fromRGBO(19, 86, 148, 1),
        items: [
          BottomBarItem(
            iconData: Icons.home,
          ),
          BottomBarItem(
            iconData: Icons.task_sharp,
            // label: 'Chat',
          ),
          BottomBarItem(
            iconData: Icons.history,
            // label: 'Notification',
          ),
          BottomBarItem(
            iconData: Icons.calendar_month,
            // label: 'Calendar',
          ),
        ],
         onSelect: _onNavTap,
        selectedIndex: _currentIndex,
      ),
    );
    
  }

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);
    if (events.isEmpty) {
      return const Center(child: Text('Tidak ada event di hari ini'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];

        // Tentukan warna berdasarkan jenis event
        Color textColor;
        String eventTypeLabel;

        if (event.type == 'done_date') {
          textColor = Colors.green; // Done date - Hijau
          eventTypeLabel = 'Done Date';
        } else if (event.type == 'due_date') {
          if (event.date.isAtSameMomentAs(DateTime.now().toLocal())) {
            textColor = Colors.red; // Due date - Merah jika hari ini
          } else {
            textColor = Colors.black; // Warna biasa jika bukan hari ini
          }
          eventTypeLabel = 'Due Date';
        } else if (event.type == 'created_task') {
          textColor = Colors.orange; // Created at - Oranye
          eventTypeLabel = 'Created At';
        } else {
          textColor = Colors.black; // Default warna
          eventTypeLabel = 'Unknown';
        }

        // Format tanggal event menjadi string
        String formattedDate = '${event.date.toLocal().toString().split(' ')[0]}';

        return ListTile(
          leading: Icon(Icons.event, color: textColor), // Icon yang bisa kamu sesuaikan
          title: Text(
            event.title,
            style: TextStyle(color: textColor),
          ),
          subtitle: Text(
            '$eventTypeLabel - $formattedDate',
            style: TextStyle(color: textColor), // Menampilkan nama event dan tanggal
          ),
        );
      },
    );
    
  }
  
}
