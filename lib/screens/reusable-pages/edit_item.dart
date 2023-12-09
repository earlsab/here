import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditItem extends StatelessWidget {
  EditItem(this._Item, {Key? key}) {
    _controllerName = TextEditingController(text: _Item['student-id']);
    // _controllerQuantity =
    //     TextEditingController(text: _shoppingItem['quantity']);

    _reference =
        FirebaseFirestore.instance.collection('attendance').doc(_Item['id']);
  }

  Map _Item;
  late DocumentReference _reference;

  late TextEditingController _controllerName;
  // late TextEditingController _controllerQuantity;
  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration:
                    InputDecoration(hintText: 'Enter the name of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }

                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      String name = _controllerName.text;

                      //Create the Map of data
                      Map<String, String> dataToUpdate = {
                        'student-id': name,
                      };

                      //Call update()
                      _reference.update(dataToUpdate);
                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
