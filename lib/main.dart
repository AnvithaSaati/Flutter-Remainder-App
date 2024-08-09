import 'package:flutter/material.dart';
import 'utils/notification_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
      home: ReminderPage(),
    );
  }
}

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  String _selectedDay = 'Monday';
  DateTime _selectedTime = DateTime.now();
  String _selectedActivity = 'Wake up';

  final List<String> _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> _activities = ['Wake up', 'Go to gym', 'Breakfast', 'Meetings', 'Lunch', 'Quick nap', 'Go to library', 'Dinner', 'Go to sleep'];

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  void _setReminder() {
    _notificationService.scheduleNotification(_selectedTime, _selectedActivity);
    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reminder Set'),
          content: Text('Your reminder for $_selectedActivity at ${_formatTime(_selectedTime)} has been set.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Center(
        child: Container(
          width: 400, // Adjust the width here
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedDay,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDay = newValue!;
                        });
                      },
                      items: _daysOfWeek.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      isExpanded: true,
                      hint: Text('Select Day'),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_selectedTime),
                      );
                      if (time != null) {
                        setState(() {
                          _selectedTime = DateTime(
                            _selectedTime.year,
                            _selectedTime.month,
                            _selectedTime.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    },
                    child: Text('Select Time'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedActivity,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedActivity = newValue!;
                  });
                },
                items: _activities.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isExpanded: true,
                hint: Text('Select Activity'),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _setReminder,
                child: Text('Set Reminder'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
