import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ServiceStorage{
  final storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadFile(String name, File file) async{
    final fileRef=storageRef.child(name);
    String imageUrl= "";

    try {
      await fileRef.putFile(file);
      imageUrl = await fileRef.getDownloadURL();
    } on FirebaseException {
      // ...
    }
    return imageUrl;

  }
  Future<List<String>> uploadMultipleFiles(List<String?> names, List<File> files) async{
    List<String> urlList = [];
    for(int i=0; i<names.length; i++){
      urlList.add(await uploadFile(names[i]!, files[i]));
    }
    return urlList;

  }
}