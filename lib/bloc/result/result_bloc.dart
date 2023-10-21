import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock/data_model/customer_data.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/repository/result_repository.dart';

part 'result_event.dart';
part 'result_state.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final ResultRepository _resultRepository;

  ResultBloc(this._resultRepository) : super(ResultInitial()) {
    on<ResultEvent>((event, emit) async {
      if (event is AddResultEvent) {
        await _resultRepository.addResult(event.game, event.customerData, event.gameData);
      } else if (event is DownloadResultEvent) {
        await _resultRepository.downloadResult(event.game);
      }
    });
  }
}
