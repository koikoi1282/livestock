part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GetGameListEvent extends GameEvent {}

class SaveGameEvent extends GameEvent {
  final bool isNew;
  final Game game;

  const SaveGameEvent({required this.isNew, required this.game});

  @override
  List<Object> get props => [game];
}

class DeleteGameEvent extends GameEvent {
  final String gameId;

  const DeleteGameEvent({required this.gameId});

  @override
  List<Object> get props => [gameId];
}
