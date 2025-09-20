import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  
final FirebaseStorage firebaseStorage;

StorageService({required this.firebaseStorage});


Future<({String url, String path})> putFile(File file, String refTitle, String imgPath)async{
log('$imgPath');
 var ref =  firebaseStorage.ref(refTitle);
var child= ref.child(imgPath);
await child.putFile(file);
String url= await child.getDownloadURL();
String storagePath= child.fullPath;
return (url: url, path: storagePath);
}

Future<void> deleteFile( String refTitle,String imgPath)async{
var ref= firebaseStorage.ref(refTitle);
 await ref.child(imgPath).delete();
}


}