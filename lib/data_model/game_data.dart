import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:livestock/data_model/game.dart';

const quizDataCount = 2;
const wheelDataCount = 6;

abstract class GameData extends Equatable {
  final String id;
  final String gameId;
  final String name;
  final String price;
  final String imagePath;
  final DateTime modifiedDate;

  const GameData({
    required this.id,
    required this.gameId,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.modifiedDate,
  });

  factory GameData.fromDbJson(Game game, Map<String, dynamic> map, String? imageUrl) {
    switch (game.runtimeType) {
      case Wheel:
        return WheelData(
            id: map['id'],
            gameId: map['gameId'],
            name: map['name'],
            price: map['price'],
            imagePath: map['imagePath'],
            modifiedDate: DateTime.fromMillisecondsSinceEpoch(map['modifiedDate']),
            imageUrl: imageUrl);
      case Quiz:
      default:
        return QuizData(
            id: map['id'],
            gameId: map['gameId'],
            name: map['name'],
            price: map['price'],
            imagePath: map['imagePath'],
            modifiedDate: DateTime.fromMillisecondsSinceEpoch(map['modifiedDate']),
            description: map['description'],
            descriptionUrl: imageUrl,
            quiz: map['quiz'],
            answers: List<String>.from(map['answers']),
            answerIndex: map['answer']);
    }
  }

  Map<String, dynamic> toDbJson();

  @override
  List<Object?> get props => [id, gameId, name, price, imagePath, modifiedDate];
}

class WheelData extends GameData {
  final String? imageUrl;

  const WheelData({
    required super.id,
    required super.gameId,
    required super.name,
    required super.price,
    required super.imagePath,
    required super.modifiedDate,
    required this.imageUrl,
  });

  factory WheelData.anonymous(String gameId) => WheelData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gameId: gameId,
      price: '',
      imagePath: '',
      modifiedDate: DateTime.now(),
      name: '',
      imageUrl: '');

  WheelData copy({
    String? gameId,
    String? name,
    String? imageUrl,
    String? imagePath,
    Uint8List? imageData,
    String? price,
    DateTime? modifiedDate,
  }) =>
      WheelData(
          id: id,
          gameId: gameId ?? this.gameId,
          name: name ?? this.name,
          price: price ?? this.price,
          imagePath: imagePath ?? this.imagePath,
          modifiedDate: modifiedDate ?? this.modifiedDate,
          imageUrl: imageUrl ?? this.imageUrl);

  @override
  Map<String, dynamic> toDbJson() => {
        'gameId': gameId,
        'name': name,
        'price': price,
        'imagePath': imagePath,
        'modifiedDate': modifiedDate.millisecondsSinceEpoch
      };

  @override
  List<Object?> get props => [...super.props, imageUrl];
}

class QuizData extends GameData {
  final String description;
  final String? descriptionUrl;
  final String quiz;
  final List<String> answers;
  final int answerIndex;

  const QuizData({
    required super.id,
    required super.gameId,
    required super.name,
    required super.price,
    required super.imagePath,
    required super.modifiedDate,
    required this.description,
    this.descriptionUrl,
    required this.quiz,
    required this.answers,
    required this.answerIndex,
  });

  factory QuizData.anonymous(String gameId) => QuizData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gameId: gameId,
      name: '',
      price: '',
      imagePath: '',
      modifiedDate: DateTime.now(),
      description: '',
      quiz: '',
      answers: List.filled(3, ''),
      answerIndex: 0);

  QuizData copy({
    String? gameId,
    String? name,
    String? price,
    String? imagePath,
    DateTime? modifiedDate,
    String? description,
    String? descriptionUrl,
    String? quiz,
    List<String>? answers,
    int? answerIndex,
  }) =>
      QuizData(
        id: id,
        gameId: gameId ?? this.gameId,
        name: name ?? this.name,
        price: price ?? this.price,
        imagePath: imagePath ?? this.imagePath,
        modifiedDate: modifiedDate ?? this.modifiedDate,
        description: description ?? this.description,
        descriptionUrl: descriptionUrl ?? this.descriptionUrl,
        quiz: quiz ?? this.quiz,
        answers: answers ?? this.answers,
        answerIndex: answerIndex ?? this.answerIndex,
      );

  @override
  Map<String, dynamic> toDbJson() => {
        'gameId': gameId,
        'name': name,
        'price': price,
        'imagePath': imagePath,
        'answer': answerIndex,
        'answers': answers,
        'description': description,
        'quiz': quiz,
        'modifiedDate': modifiedDate.millisecondsSinceEpoch
      };

  @override
  List<Object?> get props => [...super.props, description, descriptionUrl, quiz, answers, answerIndex];
}
