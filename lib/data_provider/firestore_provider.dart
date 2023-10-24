import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livestock/data_model/customer_data.dart';
import 'package:livestock/data_model/game_data.dart';

class FirestoreProvider {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getGameList() async =>
      firestore.collection('game').orderBy('modifiedDate', descending: false).get().then((value) => value.docs);

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> loadGameData(
          String collectionName, String id) async =>
      firestore
          .collection(collectionName)
          .where('gameId', isEqualTo: id)
          .orderBy('modifiedDate', descending: false)
          .get()
          .then((value) => value.docs);

  static Future<void> saveGame(bool isNew, String id, Map<String, dynamic> map) async {
    if (!isNew) {
      await firestore.collection('game').doc(id).update(map);
    } else {
      await firestore.collection('game').doc(id).set(map);
    }
  }

  static Future<void> deleteGame(String id) async => await firestore.collection('game').doc(id).delete();

  static Future<void> saveGameData(String id, String collectionName, Map<String, dynamic> map) async =>
      await firestore.collection(collectionName).doc(id).set(map);

  static Future<void> deleteGameData(String collectionName, GameData gameData) async =>
      await firestore.collection(collectionName).doc(gameData.id).delete();

  static Future<void> deleteGameDataByGameId(String collectionName, String gameId) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots =
        await firestore.collection(collectionName).where('gameId', isEqualTo: gameId).get().then((value) => value.docs);

    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in snapshots) {
      await firestore.collection(collectionName).doc(snapshot.id).delete();
    }
  }

  static Future<void> addResult(String gameId, CustomerData customerData, String price) async {
    await firestore.collection('result').add({'gameId': gameId, ...customerData.toDbJson(), 'price': price});
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getResults(String id) async =>
      firestore.collection('result').where('gameId', isEqualTo: id).get().then((value) => value.docs);

  static Future<void> deleteResultByGameId(String gameId) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots =
        await firestore.collection('result').where('gameId', isEqualTo: gameId).get().then((value) => value.docs);

    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in snapshots) {
      await firestore.collection('result').doc(snapshot.id).delete();
    }
  }
}
