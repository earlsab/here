import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:here/screens/reusable-pages/edit_item.dart';

// FIXME: Broken when put in horizontal mode
class ItemDetails extends StatelessWidget {
  Map item;
  late DocumentReference _reference;
  //_reference.get()  --> returns Future<DocumentSnapshot>
  //_reference.snapshots() --> Stream<DocumentSnapshot>
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item details'),
        actions: [
          IconButton(
              onPressed: () {
                //add the id to the map
                data['id'] = item['id'];

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditItem(data)));
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                //Delete the item
                _reference.delete();
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Some error occurred ${snapshot.error}');
          }

          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data;
            // data = documentSnapshot.data() as Map;
            if (documentSnapshot.exists) {
              if (data != null && data is Map<dynamic, dynamic>) {
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
                                  _reference.update({
                                    'photo_validation_status':
                                        'for-processing-user-delete',
                                  });
                                },
                                child: Text('Delete User'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _reference.update({
                                    'photo_validation_status':
                                        'for-processing-purge-collection',
                                  });
                                  // Handle button 2 press
                                },
                                child: Text('Delete Collection'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _reference.update({
                                    'photo_validation_status':
                                        'for-processing-user-associate',
                                  });
                                },
                                child: Text('Associate Face'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _reference.update({
                                    'photo_validation_status': 'for-processing',
                                  });
                                },
                                child: Text('Re-process'),
                              ),
                            ],
                          ),
                        ),
                      item['data'].containsKey('image')
                          ? Image.network('${item['data']['image']}')
                          : Container(),
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
                          children: [
                            Text('Matched ID: ${data['matched_id']}'),
                            Text(
                                'Photo Validation Status: ${data['photo_validation_status']}'),
                            Text('New Face: ${data['new_face']}'),
                            Text('CF OUTPUT: ${data['cf_output']}'),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
