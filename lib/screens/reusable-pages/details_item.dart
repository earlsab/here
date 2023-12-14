import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:here/screens/reusable-pages/edit_item.dart';

// FIXME: Broken when put in horizontal mode
class ItemDetails extends StatefulWidget {
  Map item;
  late DocumentReference _reference;
  late Future<DocumentSnapshot>? _futureData;
  late dynamic? data;
  ItemDetails(this.item, {Key? key}) : super(key: key) {
    _reference =
        FirebaseFirestore.instance.collection('attendance').doc(item['id']);

    _futureData = _reference.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
        return doc;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  var vertical;

  final List<bool> _selected = <bool>[false, false];

  bool isImageVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item details'),
        actions: [
          IconButton(
              onPressed: () {
                //add the id to the map
                widget.data['id'] = widget.item['id'];

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditItem(widget.data)));
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                //Delete the item
                widget._reference.delete();
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: widget._reference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Some error occurred ${snapshot.error}');
          }

          if (snapshot.hasData && snapshot.data?.data() != null) {
            Map<String, dynamic> data =
                snapshot.data?.data() as Map<String, dynamic>;
            DocumentSnapshot documentSnapshot = snapshot.data;
            // data = documentSnapshot.data() as Map;
            if (documentSnapshot.exists) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (true) // Add condition to show buttons
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle button 1 press
                                widget._reference.update({
                                  'photo_validation_status':
                                      'for-processing-user-delete',
                                });
                              },
                              child: Text('Delete User'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget._reference.update({
                                  'photo_validation_status':
                                      'for-processing-purge-collection',
                                });
                                // Handle button 2 press
                              },
                              child: Text('Delete Collection'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget._reference.update({
                                  'photo_validation_status':
                                      'for-processing-user-associate',
                                });
                              },
                              child: Text('Associate Face'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget._reference.update({
                                  'photo_validation_status': 'for-processing',
                                });
                              },
                              child: Text('Re-process'),
                            ),
                          ],
                        ),
                      ),

                    Row(
                      children: [
                        // ...

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isImageVisible =
                                  !isImageVisible; // Toggle the image visibility
                            });
                          },
                          child: Text(isImageVisible
                              ? 'Collapse Image'
                              : 'Expand Image'), // Change button text based on image visibility
                        ),
                      ],
                    ),

                    // ...

                    Visibility(
                      visible:
                          isImageVisible, // Control the visibility of the image
                      child: widget.item['data'].containsKey('image')
                          ? Image.network('${widget.item['data']['image']}')
                          : Container(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '${data['student-id']}',
                            style: TextStyle(fontSize: 20),
                            textAlign:
                                TextAlign.left, // Set the desired font size
                          ),
                        ),
                      ],
                    ),
                    ToggleButtons(
                      isSelected: [
                        data['attendance_status'] == 'IN',
                        data['attendance_status'] == 'OUT',
                      ],
                      // TODO: Set values for late according event details
                      // direction:
                      //     vertical ? Axis.vertical : Axis.horizontal,
                      onPressed: (int index) {
                        if (!_selected[index]) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              var minutes = null;
                              var timeout = null;
                              var attendanceConfirmationText =
                                  "Are you sure you want to change the attendance status?";

                              if (data['attendance_status'] != null) {
                                var timestamp =
                                    data['Timestamp_Last_Attendance_Status'];
                                var dateTime = timestamp.toDate();
                                var now = DateTime.now();
                                var difference = now.difference(dateTime);
                                var hours = difference.inHours;
                                var minutes = difference.inMinutes;
                                var seconds = difference.inSeconds;
                                if (data['attendance_status'] == 'OUT') {
                                  if (hours > 0) {
                                    attendanceConfirmationText =
                                        "$attendanceConfirmationText This person has been 'OUT' for ${hours.toString()} hour/s";
                                  } else if (minutes > 0) {
                                    attendanceConfirmationText =
                                        "$attendanceConfirmationText This person has been 'OUT' for ${minutes.toString()} minute/s";
                                  } else if (seconds > 0) {
                                    attendanceConfirmationText =
                                        "$attendanceConfirmationText This person has been 'OUT' for ${seconds.toString()} seconds/s";
                                  }
                                }
                              }

                              // var timeOut = DateTime.now().difference(timestamps);
                              if (!_selected[index]) {
                                return AlertDialog(
                                  title: Text('Confirmation'),
                                  content: Text(attendanceConfirmationText),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          // The button that is tapped is set to true, and the others to false.
                                          for (int i = 0;
                                              i < _selected.length;
                                              i++) {
                                            _selected[i] = i == index;
                                            if (_selected[0]) {
                                              if (data['attendance_status'] !=
                                                  'IN') {
                                                widget._reference.update({
                                                  'attendance_status': 'IN',
                                                  'Timestamp_Last_Attendance_Status':
                                                      DateTime.now(),
                                                });
                                              }
                                            } else {
                                              if (data['attendance_status'] !=
                                                  'OUT') {
                                                widget._reference.update({
                                                  'attendance_status': 'OUT',
                                                  'Timestamp_Last_Attendance_Status':
                                                      DateTime.now(),
                                                });
                                              }
                                            }
                                          }
                                        });
                                      },
                                      child: Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No'),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                        }
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.red[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.red[200],
                      color: Colors.red[400],
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      children: [
                        Text('in'),
                        Text('out'),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var key in data.keys)
                            if (key != 'cf_output')
                              Text('$key: ${data[key]}\n'),
                          if (data.containsKey('cf_output'))
                            Text('cf_output: ${data['cf_output']}\n')
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
