part of 'game_data_bloc.dart';

sealed class GameDataEvent extends Equatable {
  const GameDataEvent();

  @override
  List<Object> get props => [];
}

class ResetGameDataEvent extends GameDataEvent {}

class LoadGameDataEvent extends GameDataEvent {
  final Game game;

  const LoadGameDataEvent({required this.game});

  @override
  List<Object> get props => [game];
}

class SaveGameDataEvent extends GameDataEvent {
  final Game game;
  final List<GameData> gameDatas;

  const SaveGameDataEvent({required this.game, required this.gameDatas});

  @override
  List<Object> get props => [game, gameDatas];
}

class DeleteGameDatasByGameId extends GameDataEvent {
  final Game game;

  const DeleteGameDatasByGameId({required this.game});

  @override
  List<Object> get props => [game];
}
