import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:here/screens/reusable-pages/details_item.dart';
import 'add_item.dart';

// FIXME: Broken on debug mode. Some cache does not refresh and data lingers
class ItemList extends StatelessWidget {
  ItemList({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('attendance');

  //_reference.get()  ---> returns Future<QuerySnapshot>
  //_reference.snapshots()--> Stream<QuerySnapshot> -- realtime updates
  late Stream<QuerySnapshot> _stream;

  // FIXME: App fails when there's no internet
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Check error
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          //Check if data arrived
          if (snapshot.hasData) {
            //get the data
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Convert the documents to Maps
            List<Map> items = documents
                .map((e) => {
                      'id': e.id,
                      'data': e.data() as Map,
                    })
                .toList();

            // Group items by attendance status and verification status
            Map<String, Map<String, List<Map>>> groupedItems = {};
            for (var item in items) {
              String attendanceStatus = item['data']['attendance_status'];
              String verificationStatus = item['data']['verification_status'];
              if (!groupedItems.containsKey(attendanceStatus)) {
                groupedItems[attendanceStatus] = {};
              }
              if (!groupedItems[attendanceStatus]!
                  .containsKey(verificationStatus)) {
                groupedItems[attendanceStatus]![verificationStatus] = [];
              }
              groupedItems[attendanceStatus]![verificationStatus]?.add(item);
            }

            // Sort attendance status
            List<String> sortedAttendanceStatus = groupedItems.keys.toList();
            sortedAttendanceStatus.sort((a, b) {
              if (a == 'N/A') {
                return -1;
              } else if (b == 'N/A') {
                return 1;
              } else if (a == 'OUT') {
                return -1;
              } else if (b == 'OUT') {
                return 1;
              } else {
                return -1;
              }
            });

            // Display the grouped list
            return ListView.builder(
              itemCount: sortedAttendanceStatus.length,
              itemBuilder: (BuildContext context, int attendanceIndex) {
                String attendanceStatus =
                    sortedAttendanceStatus.elementAt(attendanceIndex);
                Map<String, List<Map>> itemsByAttendanceStatus =
                    groupedItems[attendanceStatus]!;

                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        '$attendanceStatus',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (attendanceStatus == 'N/A')
                      ExpansionTile(
                        title: Text('Needs Action'),
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            color: Colors.yellow,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: itemsByAttendanceStatus.length,
                              itemBuilder: (BuildContext context,
                                  int verificationIndex) {
                                String verificationStatus =
                                    itemsByAttendanceStatus.keys
                                        .elementAt(verificationIndex);
                                List<Map> itemsByVerificationStatus =
                                    itemsByAttendanceStatus[
                                        verificationStatus]!;

                                return Column(
                                  children: [
                                    ListTile(),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          itemsByVerificationStatus.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Map thisItem =
                                            itemsByVerificationStatus[index];
                                        return Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                '${thisItem['data']['student-id']}',
                                                style: TextStyle(fontSize: 24),
                                              ),
                                              leading: Container(
                                                height: 80,
                                                width: 80,
                                                child: thisItem['data']
                                                        .containsKey('image')
                                                    ? Image.network(
                                                        '${thisItem['data']['image']}')
                                                    : Container(),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ItemDetails(
                                                                thisItem)));
                                              },
                                            ),
                                            Divider(),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    if (attendanceStatus != 'N/A')
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: itemsByAttendanceStatus.length,
                        itemBuilder:
                            (BuildContext context, int verificationIndex) {
                          String verificationStatus = itemsByAttendanceStatus
                              .keys
                              .elementAt(verificationIndex);
                          List<Map> itemsByVerificationStatus =
                              itemsByAttendanceStatus[verificationStatus]!;

                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  '$verificationStatus',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: itemsByVerificationStatus.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map thisItem =
                                      itemsByVerificationStatus[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          '${thisItem['data']['student-id']}',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                        leading: Container(
                                          height: 80,
                                          width: 80,
                                          child: thisItem['data']
                                                  .containsKey('image')
                                              ? Image.network(
                                                  '${thisItem['data']['image']}')
                                              : Container(),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ItemDetails(thisItem)));
                                        },
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                );
              },
            );
          }

          //Show loader
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddItem()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
