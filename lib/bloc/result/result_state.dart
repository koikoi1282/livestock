part of 'result_bloc.dart';

sealed class ResultState extends Equatable {
  const ResultState();
  
  @override
  List<Object> get props => [];
}

final class ResultInitial extends ResultState {}
