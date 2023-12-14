import 'package:flutter/material.dart';
import 'package:here/screens/text-effects/animate_textfield.dart';
import 'package:intl/intl.dart'; 

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});
  
  @override
  State<CreateEvent> createState() => _CreateEventState();
  }

class _CreateEventState extends State<CreateEvent> {
  
  Future<DateTime?> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2010), 
      lastDate: DateTime(2030),
    );
    return picked;
  }

  Future<TimeOfDay?> _showTimePicker(BuildContext context, TimeOfDay initialTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    return picked;
  }

  // Declare a TextEditingController
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
    String formattedStartTime = '';
    String formattedEndTime = '';
    String formattedDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: const Color.fromARGB(255, 229, 231, 240),
      ),
      
      backgroundColor: const Color.fromARGB(255, 229, 231, 240),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10), 
              child: AnimatedTextField(label: "Event name", suffix: null),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: AnimatedTextField(label: "Location", suffix: null),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _dateController, // Assign a TextEditingController for the date
                readOnly: true, // This makes the field uneditable
                onTap: () async {
                  // Call the _showDatePicker function and get the selected date
                  final DateTime? date = await _showDatePicker(context);
                  // If a date is selected, format it and set it as the text of the TextFormField
                  if (date != null) {
                    formattedDate = DateFormat.yMd().format(date); // Format the date as you need
                    _dateController.text = formattedDate;
                  }
                },
                decoration: InputDecoration(
                  labelText: formattedDate.isEmpty ? 'Date' : formattedDate,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _startTimeController, // Assign the TextEditingController to the TextFormField
                readOnly: true, // This makes the field uneditable
                onTap: () async {
                  // Call the _showTimePicker function and get the selected time
                  final TimeOfDay? startTime = await _showTimePicker(context, const TimeOfDay(hour: 8, minute: 0));
                  // If a time is selected, format it and set it as the text of the TextFormField
                  if (startTime != null) {
                    final period = startTime.hour >= 12 ? 'PM' : 'AM';
                    final hour = startTime.hourOfPeriod;
                    formattedStartTime = '${hour == 0 ? 12 : hour}:${startTime.minute.toString().padLeft(2, '0')} $period';
                    _startTimeController.text = formattedStartTime;
                  }
                },
                decoration: InputDecoration(
                  labelText: formattedStartTime.isEmpty ? 'Start' : formattedStartTime,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _endTimeController, // Assign the TextEditingController to the TextFormField
                readOnly: true, // This makes the field uneditable
                onTap: () async {
                  // Call the _showTimePicker function and get the selected time
                  final TimeOfDay? endTime = await _showTimePicker(context, const TimeOfDay(hour: 17, minute: 0));
                  // If a time is selected, format it and set it as the text of the TextFormField
                  if (endTime != null) {
                    final period = endTime.hour >= 12 ? 'PM' : 'AM';
                    final hour = endTime.hourOfPeriod;
                    formattedEndTime = '${hour == 0 ? 12 : hour}:${endTime.minute.toString().padLeft(2, '0')} $period';
                    _endTimeController.text = formattedEndTime;
                  }
                },
                decoration: InputDecoration(
                  labelText: formattedEndTime.isEmpty ? 'End Time' : formattedEndTime,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: AnimatedTextField(label: "Allowable Off-Time", suffix: null),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 250, // Set the width you want here
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 60, 159, 212), 
                  ),
                  child: const Text(
                    'Create New Event',
                    style: TextStyle(color: Colors.white, fontSize: 16), 
                  ),
                ),
              ),                   
            ),                 
          ],
        ),
      ),
    );
  }
}

class CustomBorderPainter extends  CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}