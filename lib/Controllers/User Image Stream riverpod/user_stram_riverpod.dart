// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final userDocStreamPovider = StreamProvider.autoDispose<DocumentSnapshot<Map<String, dynamic>>>((ref) {
//   final uid = FirebaseAuth.instance.currentUser?.uid;
//   if (uid == null) {
//     throw Exception('User not logged in');
//   }

//   return FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .snapshots();
// });
