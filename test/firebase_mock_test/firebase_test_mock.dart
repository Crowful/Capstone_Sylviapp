import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

void main() async {
  // final instance = FakeFirebaseFirestore();
  // await instance.collection('users').add({
  //   'username': 'Bob',
  // });
  // final snapshot = await instance.collection('users').get();
  // print(snapshot.docs.length); // 1
  // print(snapshot.docs.first['username']); // 'Bob'
  // print(instance.dump());

  // final storage = MockFirebaseStorage();
  // final storageRef = storage.ref().child('filename');
  // final image = File('filename');
  // await storageRef.putFile(image);

  // String? storageSnapshot = await storageRef.getDownloadURL();

  // String? link = storageSnapshot.toString();
  // // Prints 'gs://some-bucket//someimage.png'.
  // print(link);
}
