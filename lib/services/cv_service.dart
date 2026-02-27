import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cv_model.dart';

class CvService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> addCv(CvModel cv) async {
    final data = cv.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('cvs')
        .add(data);
  }

  Stream<List<CvModel>> getCvs() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('cvs')
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CvModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> deleteCv(String cvId) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('cvs')
        .doc(cvId)
        .delete();
  }

  Future<void> updateCv(String cvId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('cvs')
        .doc(cvId)
        .update(data);
  }
}
