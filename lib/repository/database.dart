import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weight_tracker/models/weight_object.dart';

class DatabaseRepository {
  Firestore firestore;

  DatabaseRepository() {
    this.firestore = Firestore.instance;
  }

  Future<void> addWeight(String uid, double weight) async {
    var batch = firestore.batch();
    try {
      batch.setData(
          firestore
              .collection('users')
              .document(uid)
              .collection('weights')
              .document(),
          {
            'weight': weight,
            'timestamp': DateTime.now(),
          });

      batch.updateData(
          firestore.collection('users').document(uid), {'weight': weight});
      await batch.commit();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateWeight(String uid, double weight, String docId) async {
    try {
      await firestore
          .collection('users')
          .document(uid)
          .collection('weights')
          .document(docId)
          .updateData({
        'weight': weight,
      });
    } catch (e) {}
  }

  @override
  Stream<QuerySnapshot> getWeights(String uid) {
    return firestore
        .collection('users')
        .document(uid)
        .collection('weights')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot> getCurrentWeight(String uid) {
    return Firestore.instance.collection('users').document(uid).snapshots();
  }

  @override
  Future<void> updateCurrentWeight(String uid, double weight) async {
    return await firestore
        .collection('users')
        .document(uid)
        .updateData({'weight': weight});
  }
}
