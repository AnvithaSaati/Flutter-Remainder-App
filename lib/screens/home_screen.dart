// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/remainder.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedDay = 'Monday';
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedActivity = 'Wake up';

  List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<String> activities = ['Wake up', 'Go to gym', 'Breakfast', 'Meetings', 'Lunch', 'Quick nap', 'Go to library', 'Dinner', 'Go to sleep'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for Day Selection
            DropdownButton<String>(
              value: selectedDay,
              onChanged: (value) {
                setState(() {
                  selectedDay = value!;
                });
              },
              items: days.map<DropdownMenuItem<String>>((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),

            SizedBox(height: 16.0),

            // Time Picker for Time Selection
            TextButton(
              onPressed: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (time != null) {
                  setState(() {
                    selectedTime = time;
                  });
                }
              },
              child: Text('Select Time: ${selectedTime.format(context)}'),
            ),

            SizedBox(height: 16.0),

            // Dropdown for Activity Selection
            DropdownButton<String>(
              value: selectedActivity,
              onChanged: (value) {
                setState(() {
                  selectedActivity = value!;
                });
              },
              items: activities.map<DropdownMenuItem<String>>((String activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
            ),

            SizedBox(height: 32.0),

            // Button to Set Reminder
            ElevatedButton(
              onPressed: () {
                Reminder reminder = Reminder(
                  day: selectedDay,
                  time: selectedTime,
                  activity: selectedActivity,
                );
                // Store the reminder and set notification (to be implemented)
              },
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

