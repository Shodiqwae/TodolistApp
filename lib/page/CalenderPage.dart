import 'dart:convert';
import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:todolist_app/model/calenderevent.dart';
import 'package:todolist_app/page/HistoryPage.dart';
import 'package:todolist_app/page/Home.dart';
import 'package:todolist_app/page/Task.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tambahkan import ini


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
    initializeDateFormatting('id_ID', null);
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
        // Calendar page - already on this page
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Kalender Tugas', style: TextStyle(color: Colors.white, fontFamily: "Mont-SemiBold"),),
        backgroundColor: const Color.fromARGB(255, 20, 61, 227),
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
            // Remove the "2 weeks" display
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(
              formatButtonVisible: false, 
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
          ),
          BottomBarItem(
            iconData: Icons.history,
          ),
          BottomBarItem(
            iconData: Icons.calendar_month,
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

  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  return ListView.builder(
    itemCount: events.length,
    itemBuilder: (context, index) {
      final event = events[index];

      // Default value
      Color textColor = Colors.black;
      String eventTypeLabel = 'Unknown';
      bool isPastDue = false;

      // Cari due_date dan done_date dari event yang sama (berdasarkan title atau id jika ada)
      CalendarEvent? matchingDueDate;
      CalendarEvent? matchingDoneDate;

      // Jika event ini due_date atau done_date, coba cari pasangannya
      if (event.type == 'due_date') {
        matchingDoneDate = events.firstWhere(
          (e) => e.title == event.title && e.type == 'done_date',
          orElse: () => CalendarEvent.empty(),
        );
      } else if (event.type == 'done_date') {
        matchingDueDate = events.firstWhere(
          (e) => e.title == event.title && e.type == 'due_date',
          orElse: () => CalendarEvent.empty(),
        );
      }

      // Tentukan warna dan label berdasarkan tipe
      if (event.type == 'done_date') {
        textColor = Colors.green;
        eventTypeLabel = 'Done Date';

        // Periksa apakah ada due_date, lalu bandingkan tanggal
        if (matchingDueDate != null && !matchingDueDate.isEmpty) {
          final due = DateTime(matchingDueDate.date.year, matchingDueDate.date.month, matchingDueDate.date.day);
          final done = DateTime(event.date.year, event.date.month, event.date.day);
          if (done.isAfter(due)) {
            isPastDue = true;
          }
        }
      } else if (event.type == 'due_date') {
        final eventDate = DateTime(event.date.year, event.date.month, event.date.day);

        if (eventDate.compareTo(today) < 0) {
          textColor = Colors.red;
          isPastDue = true;
        } else if (eventDate.compareTo(today) == 0) {
          textColor = Colors.red;
        }

        eventTypeLabel = 'Due Date';

        if (matchingDoneDate != null && !matchingDoneDate.isEmpty) {
          final due = DateTime(event.date.year, event.date.month, event.date.day);
          final done = DateTime(matchingDoneDate.date.year, matchingDoneDate.date.month, matchingDoneDate.date.day);

          if (!done.isAfter(due)) {
            isPastDue = false; // Done tepat waktu
          } else {
            isPastDue = true; // Done terlambat
          }
        }
      } else if (event.type == 'created_task') {
        textColor = Colors.orange;
        eventTypeLabel = 'Created At';
      }

      String formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(event.date.toLocal());

      String subtitleText = '$eventTypeLabel - $formattedDate';
      if (isPastDue) {
        subtitleText += ' | Lewat tenggat waktu';
      }

      return InkWell(
        onTap: () {
          if (event.type == 'due_date') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(token: _token)));
          } else if (event.type == 'done_date') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Historypage(token: _token)));
          } else if (event.type == 'created_task') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TaskPage(token: _token)));
          }
        },
        child: ListTile(
          leading: Icon(Icons.event, color: textColor),
          title: Text(event.title, style: TextStyle(color: textColor)),
          subtitle: Text(subtitleText, style: TextStyle(color: textColor)),
        ),
      );
    },
  );
}

}