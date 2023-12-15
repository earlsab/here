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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddItem()));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //Check error
              if (snapshot.hasError) {
                return Center(
                    child: Text('Some error occurred ${snapshot.error}'));
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
                  String verificationStatus =
                      item['data']['verification_status'];
                  if (!groupedItems.containsKey(attendanceStatus)) {
                    groupedItems[attendanceStatus] = {};
                  }
                  if (!groupedItems[attendanceStatus]!
                      .containsKey(verificationStatus)) {
                    groupedItems[attendanceStatus]![verificationStatus] = [];
                  }
                  groupedItems[attendanceStatus]![verificationStatus]
                      ?.add(item);
                }

                // Sort attendance status
                List<String> sortedAttendanceStatus =
                    groupedItems.keys.toList();
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
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  10), // Add margin to prevent borders from touching the device's borders
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  '$attendanceStatus',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (attendanceStatus == 'N/A')
                                ExpansionTile(
                                  title: Text('Needs Action'),
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.yellow,
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            itemsByAttendanceStatus.length,
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
                                              SizedBox(height: 10),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    itemsByVerificationStatus
                                                        .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  Map thisItem =
                                                      itemsByVerificationStatus[
                                                          index];
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          '${thisItem['data']['student-id']}',
                                                          style: TextStyle(
                                                              fontSize: 24),
                                                        ),
                                                        leading: Container(
                                                          height: 80,
                                                          width: 80,
                                                          child: thisItem[
                                                                      'data']
                                                                  .containsKey(
                                                                      'image')
                                                              ? Image.network(
                                                                  '${thisItem['data']['image']}')
                                                              : Container(),
                                                        ),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                ItemDetails(
                                                                    thisItem),
                                                          ));
                                                        },
                                                        trailing: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: thisItem['data']
                                                                        [
                                                                        'verification_status'] ==
                                                                    'verified'
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                          child: Text(
                                                            thisItem['data'][
                                                                'verification_status'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      if (index !=
                                                          itemsByVerificationStatus
                                                                  .length -
                                                              1)
                                                        Divider(),
                                                      SizedBox(height: 10),
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
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              itemsByVerificationStatus.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Map thisItem =
                                                itemsByVerificationStatus[
                                                    index];
                                            return Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    '${thisItem['data']['student-id']}',
                                                    style:
                                                        TextStyle(fontSize: 24),
                                                  ),
                                                  leading: Container(
                                                    height: 80,
                                                    width: 80,
                                                    child: thisItem['data']
                                                            .containsKey(
                                                                'image')
                                                        ? Image.network(
                                                            '${thisItem['data']['image']}')
                                                        : Container(),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          ItemDetails(thisItem),
                                                    ));
                                                  },
                                                  trailing: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: thisItem['data'][
                                                                  'verification_status'] ==
                                                              'verified'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                    child: Text(
                                                      thisItem['data'][
                                                          'verification_status'],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (index !=
                                                    itemsByVerificationStatus
                                                            .length -
                                                        1)
                                                  Divider(),
                                                SizedBox(height: 10),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10), // Add spacing between sections
                      ],
                    );
                  },
                );
              } else {
                return Container();
              }
            }));
  }
}
