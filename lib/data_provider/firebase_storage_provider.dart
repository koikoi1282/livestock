import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageProvider {
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static Future<String?> getFileUrlFromPath(String path) async {
    if (path.isEmpty) {
      return null;
    }

    final Reference ref = storage.ref(path);

    return await ref.getDownloadURL();
  }

  static Future<void> uploadFile(PlatformFile file) async {
    final Reference ref = storage.ref(file.name);

    await ref.putData(
        file.bytes!,
        SettableMetadata(
          contentType: 'image/${file.extension}',
        ));
  }
}
