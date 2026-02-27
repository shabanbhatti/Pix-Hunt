import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Models/downloads_image_model.dart';
import 'package:pix_hunt_project/Models/pictures_model.dart';
import 'package:pix_hunt_project/Models/search_history.dart';

class CloudDbService {
  final FirebaseFirestore firestore;

  const CloudDbService({required this.firestore});

  Future<void> addUser(Auth auth, String uid) async {
    var doc = await firestore.collection('users').doc(uid);
    var get = await doc.get();
    if (!get.exists) {
      await doc.set(auth.toMap(uid));
    }
  }

  Future<Auth> getUserData(String uid) async {
    var user = await firestore.collection('users').doc(uid).get();
    Auth auth = Auth.fromMap(user.data()!);
    return auth;
  }

  Future<void> addToBookmark(Photos favItemModalClass, String uid) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc(favItemModalClass.id.toString())
        .set(favItemModalClass.toMap());
  }

  Future<void> deleteFavourites(Photos favItemModalClass, String uid) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc(favItemModalClass.id.toString())
        .delete();
  }

  Future<void> addDownloadedPhotos(
    DownloadsImageModel downloadImageModel,
    String uid,
  ) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('downloaded_items')
        .doc(downloadImageModel.id)
        .set(downloadImageModel.toMap());
  }

  Future<void> deleteDownloadedHistory(
    DownloadsImageModel downloadImageModel,
    String uid,
  ) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('downloaded_items')
        .doc(downloadImageModel.id)
        .delete();
  }

  Future<void> deleteAllDownloadedHistory(String uid) async {
    final collectionRef = firestore
        .collection('users')
        .doc(uid)
        .collection('downloaded_items');

    const int batchSize = 400;

    while (true) {
      final querySnapshot = await collectionRef.limit(batchSize).get();

      if (querySnapshot.docs.isEmpty) {
        break;
      }

      final batch = firestore.batch();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    }
  }

  Future<void> addSearchHistory(SearchHistory searchHistory, String uid) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('search_history')
        .doc(searchHistory.id)
        .set(searchHistory.toMap());
  }

  Future<void> removeSearchHistory(
    SearchHistory searchHistory,
    String uid,
  ) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('search_history')
        .doc(searchHistory.id)
        .delete();
  }

  Future<String?> getEmailFromDb(String uid) async {
    var doc = await firestore.collection('users').doc(uid).get();
    var data = doc.data();
    if (data == null) return null;

    String email = data['email'];
    return email;
  }

  Future<void> onLogin(String email, String uid) async {
    await firestore.collection('users').doc(uid).update({'email': email});
    await firestore.collection('users').doc(uid).update({
      'pendingEmail': FieldValue.delete(),
    });
  }

  Future<void> updateName(String name, String uid) async {
    await firestore.collection('users').doc(uid).update({'name': name});
  }

  Future<void> updateEmail(String email, String uid) async {
    await firestore.collection('users').doc(uid).update({
      'pendingEmail': email,
    });
  }

  Future<void> userImage(String uid, String imgUrl, String imgPath) async {
    await firestore.collection('users').doc(uid).update({
      'imgUrl': imgUrl,
      'img_paths': imgPath,
    });
  }

  Future<void> deleteUserImage(String uid) async {
    await firestore.collection('users').doc(uid).update({
      'imgUrl': '',
      'img_paths': '',
    });
  }

  Future<String> getUserImage(String uid) async {
    var url = await firestore.collection('users').doc(uid).get();
    var path = url['imgUrl'] ?? '';
    return path;
  }

  Future<String?> getUserImageStoragePath(String uid) async {
    var doc = await firestore.collection('users').doc(uid).get();
    var data = doc.data() ?? {};
    String? path = data['img_paths'] ?? null;
    return path;
  }

  Stream<List<Photos>> bookmarks(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Photos.fromJson(doc.data())).toList(),
        );
  }

  Stream<List<DownloadsImageModel>> downloadHistoryStream(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('downloaded_items')
        .snapshots()
        .map(
          (event) =>
              event.docs
                  .map((e) => DownloadsImageModel.fromMap(e.data()))
                  .toList(),
        );
  }

  Stream<List<SearchHistory>> searchHitoryStream(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('search_history')
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => SearchHistory.fromMap(e.data())).toList(),
        );
  }

  Future<void> deleteAccount(String uid) async {
    await firestore.collection('users').doc(uid).delete();
  }
}
