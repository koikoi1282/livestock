part of 'result_bloc.dart';

sealed class ResultEvent extends Equatable {
  const ResultEvent();

  @override
  List<Object> get props => [];
}

class AddResultEvent extends ResultEvent {
  final Game game;
  final CustomerData customerData;
  final GameData gameData;

  const AddResultEvent({required this.game, required this.customerData, required this.gameData});

  @override
  List<Object> get props => [game, customerData, gameData];
}

class DownloadResultEvent extends ResultEvent {
  final Game game;

  const DownloadResultEvent({required this.game});

  @override
  List<Object> get props => [game];
}
