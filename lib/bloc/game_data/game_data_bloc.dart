import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/repository/game_data_repository.dart';

part 'game_data_event.dart';
part 'game_data_state.dart';

class GameDataBloc extends Bloc<GameDataEvent, GameDataState> {
  final GameDataRepository _gameDataRepository;

  GameDataBloc(this._gameDataRepository) : super(GameDataInitial()) {
    on<GameDataEvent>((event, emit) async {
      if (event is ResetGameDataEvent) {
        emit(GameDataInitial());
      } else if (event is LoadGameDataEvent) {
        emit(DataLoadingState());
        List<GameData> gameDataList = await _gameDataRepository.loadGameData(event.game);

        emit(DatasState(gameDatas: gameDataList));
      } else if (event is SaveGameDataEvent) {
        await _gameDataRepository.saveGameData(event.game, event.gameDatas);
      } else if (event is DeleteGameDatasByGameId) {
        await _gameDataRepository.deleteGameDataByGameId(event.game);
      }
    });
  }
}
