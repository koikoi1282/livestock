part of 'game_data_bloc.dart';

sealed class GameDataState extends Equatable {
  const GameDataState();

  @override
  List<Object> get props => [];
}

final class GameDataInitial extends GameDataState {}

class DatasState extends GameDataState {
  final List<GameData> gameDatas;

  const DatasState({required this.gameDatas});

  @override
  List<Object> get props => [gameDatas];
}

class DataLoadingState extends GameDataState {}
