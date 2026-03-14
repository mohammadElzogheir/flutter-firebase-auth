import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cv_model.dart';

class CvService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> addCv(CvModel cv) async {
    final data = cv.toMap();
    data['ownerId'] = _uid;
    data['likesCount'] = 0;
    data['createdAt'] = DateTime.now().millisecondsSinceEpoch;

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
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CvModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Stream<List<CvModel>> getPublicCvs() {
    return _firestore
        .collectionGroup('cvs')
        .where('isPublic', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CvModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getNotifications() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
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

  Future<bool> isLiked(CvModel cv) async {
    final doc = await _firestore
        .collection('users')
        .doc(cv.ownerId)
        .collection('cvs')
        .doc(cv.id)
        .collection('likes')
        .doc(_uid)
        .get();

    return doc.exists;
  }

  Future<void> toggleLike(CvModel cv) async {
    final targetCvRef = _firestore
        .collection('users')
        .doc(cv.ownerId)
        .collection('cvs')
        .doc(cv.id);

    final likeRef = targetCvRef.collection('likes').doc(_uid);

    await _firestore.runTransaction((transaction) async {
      final likeSnap = await transaction.get(likeRef);
      final cvSnap = await transaction.get(targetCvRef);

      final currentData = cvSnap.data() ?? {};
      final currentLikes =
          currentData['likesCount'] is int ? currentData['likesCount'] as int : 0;

      if (likeSnap.exists) {
        transaction.delete(likeRef);
        transaction.update(targetCvRef, {
          'likesCount': currentLikes > 0 ? currentLikes - 1 : 0,
        });
      } else {
        transaction.set(likeRef, {
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        });

        transaction.update(targetCvRef, {
          'likesCount': currentLikes + 1,
        });

        if (cv.ownerId != _uid) {
          final myUser = _auth.currentUser;
          final fromName = myUser?.email?.split('@').first ?? 'Someone';

          final notificationRef = _firestore
              .collection('users')
              .doc(cv.ownerId)
              .collection('notifications')
              .doc();

          transaction.set(notificationRef, {
            'type': 'like',
            'fromUid': _uid,
            'fromName': fromName,
            'cvId': cv.id,
            'cvName': cv.fullName,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          });
        }
      }
    });
  }
}