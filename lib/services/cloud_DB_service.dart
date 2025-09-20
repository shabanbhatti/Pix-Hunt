import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';
import 'package:pix_hunt_project/Models/dowloads_items_model.dart';
import 'package:pix_hunt_project/Models/fav_items.dart';
import 'package:pix_hunt_project/Models/search_history.dart';

class CloudDbService {
  final FirebaseFirestore firestore;

  const CloudDbService({required this.firestore});

  Future<void> addUser(Auth auth, String uid) async {
    var doc= await firestore.collection('users').doc(uid);
var get=await doc.get();
if (!get.exists) {
  await doc.set(auth.toMap(uid));
}
  }

  Future<Auth> getUserData(String uid) async {
    var user = await firestore.collection('users').doc(uid).get();
    Auth auth = Auth.fromMap(user.data()!);
    return auth;
  }

  Future<void> addFavouriteItems(
    FavItemModalClass favItemModalClass,
    String uid,
  ) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('fav_items')
        .doc(favItemModalClass.id)
        .set(favItemModalClass.toMap());
  }

  Future<void> deleteFavourites(
    FavItemModalClass favItemModalClass,
    String uid,
  ) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('fav_items')
        .doc(favItemModalClass.id)
        .delete();
  }

  Future<void> addDownloadedPhotos(
    DownloadsItem downloadedItems,
    String uid,
  ) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('downloaded_items')
        .doc(downloadedItems.id)
        .set(downloadedItems.toMap());
  }

  Future<void> deleteDownloadedHistory(
    DownloadsItem downloadedItems,
    String uid,
  ) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('downloaded_items')
        .doc(downloadedItems.id)
        .delete();
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

  Future<void> updateName(String name, String uid) async {
    await firestore.collection('users').doc(uid).update({'name': name});
  }

  Future<void> updateEmail(String email, String uid) async {
    await firestore.collection('users').doc(uid).update({
      'pendingEmail': email,
    });
  }

  Future<void> userImage(String uid, String imgUrl, String imgPath)async{
    await firestore.collection('users').doc(uid).update({
          'imgUrl': imgUrl,
          'img_paths': imgPath
        });
  }

Future<void> deleteUserImage(String uid,)async{
 await firestore.collection('users').doc(uid).update({
          'imgUrl': FieldValue.delete(),
          'img_paths': FieldValue.delete()
        });
}

Future<String> getUserImage(String uid)async{
var url=await firestore.collection('users').doc(uid).get();
return url['imgUrl']??'';
}

  Future<void> syncEmailAfterVerification(String email, String uid) async {
    await firestore.collection('users').doc(uid).update({
      'email': email,
      'pendingEmail': FieldValue.delete(),
    });
  }

  Stream<List<FavItemModalClass>> favItemsStreams(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('fav_items')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => FavItemModalClass.fromMap(doc.data(), id: doc.id),
                  )
                  .toList(),
        );
  }


  Stream<List<DownloadsItem>> downloadHistoryStream(String uid){
    return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('downloaded_items')
      .snapshots()
      .map(
        (event) =>
            event.docs.map((e) => DownloadsItem.fromMap(e.data(),)).toList(),
      );
  }


  Stream<List<SearchHistory>> searchHitoryStream(String uid){
    return FirebaseFirestore.instance.
          collection('users')
          .doc(uid)
          .collection('search_history')
          .snapshots()
          .map(
            (event) =>
                event.docs.map((e) => SearchHistory.fromMap(e.data())).toList(),
          );
  }

}
