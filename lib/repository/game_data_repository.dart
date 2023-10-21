import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/data_provider/firebase_storage_provider.dart';
import 'package:livestock/data_provider/firestore_provider.dart';

class GameDataRepository {
  Future<List<GameData>> loadGameData(Game game) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> gameDataSnapshots =
        await FirestoreProvider.loadGameData(game.collectionName, game.id);

    List<GameData> gameDatas = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in gameDataSnapshots) {
      gameDatas.add(GameData.fromDbJson(game, snapshot.data()..addAll({'id': snapshot.id}),
          await FirebaseStorageProvider.getFileUrlFromPath(snapshot.data()['imagePath'])));
    }

    return gameDatas;
  }

  Future<void> saveGameData(Game game, List<GameData> gameDatas) async {
    List<GameData> existDatas = await loadGameData(game);

    Set<String> isUpdated = {};

    for (GameData existData in existDatas) {
      for (GameData newData in gameDatas) {
        if (existData.id == newData.id) {
          isUpdated.add(existData.id);

          await FirestoreProvider.saveGameData(newData.id, game.collectionName, newData.toDbJson());
          continue;
        }
      }
    }

    for (GameData newData in gameDatas) {
      if (isUpdated.contains(newData.id)) {
        continue;
      }

      await FirestoreProvider.saveGameData(newData.id, game.collectionName, newData.toDbJson());
    }

    for (GameData existData in existDatas) {
      if (isUpdated.contains(existData.id)) {
        continue;
      }

      await FirestoreProvider.deleteGameData(game.collectionName, existData);
    }
  }

  Future<void> deleteGameDataByGameId(Game game) async =>
      await FirestoreProvider.deleteGameDataByGameId(game.collectionName, game.id);
}
