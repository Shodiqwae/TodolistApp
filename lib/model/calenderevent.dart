class CalendarEvent {
  final String type;
  final String title;
  final DateTime date;
  

  CalendarEvent({required this.type, required this.title, required this.date});

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      type: json['type'],
      title: json['title'],
      date: DateTime.parse(json['date']),
    );
  }
factory CalendarEvent.empty() {
  return CalendarEvent(title: '', type: '', date: DateTime(2000));
}

bool get isEmpty => title == '' && type == '';

  @override
  String toString() => '$title (${typeLabel()})';

  String typeLabel() {
    switch (type) {
      case 'created_task':
        return '📝 Created';
      case 'due_date':
        return '⏰ Due';
      case 'done_date':
        return '✅ Done';
      default:
        return type;
    }
  }
}
