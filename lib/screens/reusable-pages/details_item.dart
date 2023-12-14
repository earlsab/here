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

          if (snapshot.hasData) {
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
