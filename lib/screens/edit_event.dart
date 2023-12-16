import 'package:flutter/material.dart';
import 'package:here/functions/firestore.dart';
import 'package:here/functions/globals.dart';
import 'package:here/screens/navigation_menu.dart';
import 'package:here/screens/text-effects/animate_textfield.dart';
import 'package:intl/intl.dart'; 

class EditEvent extends StatefulWidget {
  final String eventName;
  final String eventLocation;
  final String eventDate;
  final String eventStart;
  final String eventEnd;

  const EditEvent({super.key, required this.eventName, required this.eventLocation, required this.eventDate, required this.eventStart, required this.eventEnd});
  
  @override
  State<EditEvent> createState() => _EditEventState();
  }

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();
 

class _EditEventState extends State<EditEvent> {

  //Set the current event details persisent in the text fields
  @override
  void initState() {
    super.initState();
    eventNameController.text = widget.eventName;
    eventLocationController.text = widget.eventLocation;
    formattedDate = widget.eventDate;
    formattedStartTime = widget.eventStart;
    formattedEndTime = widget.eventEnd;

  }

    // Firestore
  final FirestoreService firestoreService = FirestoreService();
  
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
            Padding(
              padding: const EdgeInsets.all(10), 
              child: AnimatedTextField(
              label: "Event name", 
              suffix: null, controller: 
              eventNameController),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: AnimatedTextField(
                label: "Location", 
                suffix: null, 
                controller: eventLocationController),
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity, // Set the width you want here
                child: ElevatedButton(
                  onPressed: () { firestoreService.editEvent(
                    eventNameController.text, 
                    eventLocationController.text, 
                    formattedDate,
                    formattedStartTime,
                    formattedEndTime,
                  );
                  
                  // Clear the text controller
                  eventNameController.clear();
                  eventLocationController.clear();
                  _dateController.clear();
                  _startTimeController.clear();
                  _endTimeController.clear();
                  
                  // Close the box
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                  builder: (context) => const NavigationPage()),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF749BC2), 
                  ),
                  child: const Text(
                    'Confirm Details',
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