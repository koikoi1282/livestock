import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/data_provider/firestore_provider.dart';

class GameRepository {
  List<Game> gameList = [];
  Wheel? selectedWheel;
  Quiz? selectedQuiz;

  Future<List<Game>> getGameList() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> gameSnapshots = await FirestoreProvider.getGameList();

    gameList = gameSnapshots.map((snapshot) => Game.fromDbJson(snapshot.data()..addAll({'id': snapshot.id}))).toList();
    selectedWheel = gameList.whereType<Wheel>().firstWhere((element) => element.isSelected);
    selectedQuiz = gameList.whereType<Quiz>().firstWhere((element) => element.isSelected);

    return gameList;
  }

  Future<void> saveGame(bool isNew, Game game) async =>
      await FirestoreProvider.saveGame(isNew, game.id, game.toDbJson());

  Future<void> deleteGame(String id) async => await FirestoreProvider.deleteGame(id);

  Future<void> updateSelected(Game game) async {
    late List<Game> gameList;

    if (game is Wheel) {
      gameList = (await getGameList()).whereType<Wheel>().toList();
    } else {
      gameList = (await getGameList()).whereType<Quiz>().toList();
    }

    for (Game tempGame in gameList) {
      tempGame = tempGame.copy(isSelected: false);
      await saveGame(false, tempGame);
    }
  }
}
