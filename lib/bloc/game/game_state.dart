part of 'game_bloc.dart';

sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

final class GameInitial extends GameState {}

class GameLoadingState extends GameState {}

class GameListState extends GameState {
  final List<Game> gameList;
  final Wheel? selectedWheel;
  final Quiz? selectedQuiz;

  const GameListState({required this.gameList, required this.selectedWheel, required this.selectedQuiz});
  @override
  List<Object?> get props => [gameList, selectedWheel, selectedQuiz];
}

class SingleGameState extends GameState {
  final Game game;

  const SingleGameState({required this.game});

  @override
  List<Object> get props => [game];
}
