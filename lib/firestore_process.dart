import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreProcess extends StatelessWidget {
  FirestoreProcess({super.key});

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? userSubscribe;

  @override
  Widget build(BuildContext context) {
    // ID'ler
    debugPrint(firestore.collection("users").id);
    debugPrint(firestore.collection("users").doc().id);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore Process"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  addDataFunction();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.deepOrangeAccent)),
                child: const Text(
                  "Add Data",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                onPressed: () {
                  setDataFunction();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.purple)),
                child: const Text(
                  "Set Data",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                onPressed: () {
                  updateDataFunction();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.green)),
                child: const Text(
                  "Update Data",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                onPressed: () {
                  deleteDataFunction();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.red)),
                child: const Text(
                  "Delete Data",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                onPressed: () {
                  readDataOneShotFunction();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.orange)),
                child: const Text(
                  "Read Data One Shot",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                onPressed: () {
                  readDataRealTimeFunction();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.cyan)),
                child: const Text(
                  "Read Data Real Time",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                onPressed: () {
                  batchFunction();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.brown)),
                child: const Text(
                  "Batch Process",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                onPressed: () {
                  transactionFunction();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.green)),
                child: const Text(
                  "Transaction Process",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                onPressed: () {
                  queryingDataFunction();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.purple)),
                child: const Text(
                  "Querying Data",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                onPressed: () {
                  imageUploadFunction();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue)),
                child: const Text(
                  "Image Upload",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }

  void addDataFunction() async {
    Map<String, dynamic> _additiveUser = <String, dynamic>{};
    _additiveUser["name"] = "Burak";
    _additiveUser["age"] = 28;
    _additiveUser["student"] = false;
    _additiveUser["address"] = {"province": "Bursa", "county": "Nilüfer"};
    _additiveUser["colors"] = FieldValue.arrayUnion(["Mavi", "Yeşil"]);
    _additiveUser["createdAt"] = FieldValue.serverTimestamp();

    await firestore.collection("users").add(_additiveUser);
  }

  // Set ile hem veri ekleyebilir hemde veri güncelleyebiliriz. Yanlış ID girersek yeni bir alan oluşturup veriyi orada saklar.
  void setDataFunction() async {
    // var newDocId = firestore.collection("users").doc().id;
    // await firestore
    //     .doc("users/$newDocId")
    //     .set({"name": "Burak", "userID": newDocId});

    // Set işleminde SetOptions(merge: true) yapmazsak her şeyi silip sadece set ile gönderdiğimiz veriyi kaydeder.
    await firestore.doc("users/MfCkS4vxl1e6VwbFvb9Z").set({
      "University": "Dumlupınar Üniversitesi",
      "name": "Burak",
      "age": FieldValue.increment(1)
    }, SetOptions(merge: true));
  }

  void deleteDataFunction() async {
    await firestore.doc("users/MfCkS4vxl1e6VwbFvb9Z").delete();
  }

  // Update ile güncellemeye çalıştığımız veri yoksa da oluşturulur. Ancak ID yanlışsa hata verir.
  void updateDataFunction() async {
    await firestore.doc("users/MfCkS4vxl1e6VwbFvb9Z").update(
        {"name": "Burak", "student": false, "address.province": "İzmir"});
  }

  void readDataOneShotFunction() async {
    var userDoc = await firestore.collection("users").get();
    for (var element in userDoc.docs) {
      Map userMap = element.data();
      debugPrint(userMap["name"]);
    }

    var _burakDoc = await firestore.doc("users/MfCkS4vxl1e6VwbFvb9Z").get();
    debugPrint(_burakDoc.data()!["address"]["province"].toString());
  }

  void readDataRealTimeFunction() async {
    //var userStream = await firestore.collection("users").snapshots();
    var userStream =
        await firestore.doc("users/MfCkS4vxl1e6VwbFvb9Z").snapshots();
    userSubscribe = userStream.listen((event) {
      // for (var element in event.docChanges) {
      //   debugPrint(element.doc.data().toString());
      // }
      debugPrint(event.data().toString());
    });
  }

  streamStop() async {
    await userSubscribe?.cancel();
  }

  void batchFunction() async {
    WriteBatch batch = firestore.batch();
    CollectionReference countersCollectionReference =
        firestore.collection("counters");

    // for (var i = 0; i < 100; i++) {
    //   var newDoc = countersCollectionReference.doc();
    //   batch.set(newDoc, {"counter": ++i, "id": newDoc.id});
    // }

    // var counterDoc = await countersCollectionReference.get();
    // for (var element in counterDoc.docs) {
    //   batch.update(
    //       element.reference, {"createdAt": FieldValue.serverTimestamp()});
    // }

    var counterDoc = await countersCollectionReference.get();
    for (var element in counterDoc.docs) {
      batch.delete(element.reference);
    }

    await batch.commit();
  }

  void transactionFunction() async {
    firestore.runTransaction((transaction) async {
      DocumentReference<Map<String, dynamic>> burakRef =
          firestore.doc("users/ACn55NdVfYv6iOU48pgg");
      DocumentReference<Map<String, dynamic>> bayarRef =
          firestore.doc("users/MfCkS4vxl1e6VwbFvb9Z");

      var burakSnapshot = await transaction.get(burakRef);
      var burakMoney = burakSnapshot["money"];

      if (burakMoney > 100) {
        var burakNewMoney = burakMoney - 100;
        transaction.update(burakRef, {"money": burakNewMoney});
        transaction.update(bayarRef, {"money": FieldValue.increment(100)});
      }
    });
  }

  void queryingDataFunction() async {
    var userRef = firestore.collection("users");
    var result = await userRef.where("age", isLessThanOrEqualTo: 30).get();

    // for (var user in result.docs) {
    //   debugPrint(user.data()["name"]);
    // }

    //descending = false (küçükten büyüğe)
    var sort = await userRef.orderBy("age", descending: false).get();
    for (var user in sort.docs) {
      debugPrint(user.data()["name"]);
    }
  }

  void imageUploadFunction() async {
    final ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(source: ImageSource.camera);
    var profileRef = FirebaseStorage.instance.ref("users/profile_pictures/user_id");
    var task = profileRef.putFile(File(file!.path));

    task.whenComplete(() async {
      var url = await profileRef.getDownloadURL();
      firestore
          .doc("users/ACn55NdVfYv6iOU48pgg")
          .set({"profile_picture": url.toString()}, SetOptions(merge: true));
      debugPrint(url);
    });
  }
}
