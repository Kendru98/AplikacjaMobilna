import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
    // funkcja odpowiedzialna za wysyłanie pliku do magazynu
    String filepath, // wybrany plik
    String fileName, // docelowa nazwa pliku czyli uid użytkownika
  ) async {
    File plik = File(filepath);
    try {
      await storage
          .ref('Avatars/$fileName')
          .putFile(plik); // odwołanie do magazynu
    } on firebase_core.FirebaseException {}
  }

  Future<String> downloadURL(String userID) async {
    try {
      String downloadURL =
          await storage.ref('Avatars').child('/$userID').getDownloadURL();
      // odwołanie do magazynu
      return downloadURL;
    } catch (error) {
      // jeżeli zdjęcia o danym ID nie ma w storage zwróć adres zdjęcia domyślnego
      String downloadURL =
          await storage.ref('Avatars').child('/default.jpg').getDownloadURL();
      // odwołanie do magazynu
      return downloadURL; // zwracam wynik
    }
  }
}
