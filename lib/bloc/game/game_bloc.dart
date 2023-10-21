import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/repository/game_repository.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;

  GameBloc(this._gameRepository) : super(GameInitial()) {
    on<GameEvent>((event, emit) async {
      if (event is GetGameListEvent) {
        emit(GameLoadingState());
        List<Game> gameList = await _gameRepository.getGameList();

        emit(GameListState(
            gameList: gameList,
            selectedWheel: _gameRepository.selectedWheel,
            selectedQuiz: _gameRepository.selectedQuiz));
      } else if (event is SaveGameEvent) {
        emit(GameLoadingState());
        if (event.game.isSelected) {
          await _gameRepository.updateSelected(event.game);
        }
        await _gameRepository.saveGame(event.isNew, event.game);
        add(GetGameListEvent());
      } else if (event is DeleteGameEvent) {
        emit(GameLoadingState());

        await _gameRepository.deleteGame(event.gameId);
        add(GetGameListEvent());
      }
    });

    add(GetGameListEvent());
  }
}
