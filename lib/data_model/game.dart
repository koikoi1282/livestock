import 'package:equatable/equatable.dart';

abstract class Game extends Equatable {
  final String id;
  final String name;
  final bool isSelected;
  final DateTime modifiedDate;

  const Game({
    required this.id,
    required this.name,
    required this.isSelected,
    required this.modifiedDate,
  });

  factory Game.fromDbJson(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'wheel':
        return Wheel(
            id: map['id'],
            name: map['name'],
            isSelected: map['isSelected'],
            modifiedDate:
                DateTime.fromMillisecondsSinceEpoch(map['modifiedDate']));
      case 'quiz':
      default:
        return Quiz(
            id: map['id'],
            name: map['name'],
            isSelected: map['isSelected'],
            modifiedDate:
                DateTime.fromMillisecondsSinceEpoch(map['modifiedDate']));
    }
  }

  Game copy(
      {String? id, String? name, bool? isSelected, DateTime? modifiedDate}) {
    if (this is Wheel) {
      return Wheel(
          id: id ?? this.id,
          name: name ?? this.name,
          isSelected: isSelected ?? this.isSelected,
          modifiedDate: modifiedDate ?? this.modifiedDate);
    }

    return Quiz(
        id: id ?? this.id,
        name: name ?? this.name,
        isSelected: isSelected ?? this.isSelected,
        modifiedDate: modifiedDate ?? this.modifiedDate);
  }

  Game changeType() {
    if (this is Wheel) {
      return Quiz(
          id: id,
          name: name,
          isSelected: isSelected,
          modifiedDate: modifiedDate);
    }

    return Wheel(
        id: id, name: name, isSelected: isSelected, modifiedDate: modifiedDate);
  }

  Map<String, dynamic> toDbJson() => {
        'name': name,
        'type': typeName,
        'isSelected': isSelected,
        'modifiedDate': modifiedDate.millisecondsSinceEpoch,
      };

  @override
  List<Object?> get props => [id, name, isSelected, modifiedDate];
}

class Wheel extends Game {
  const Wheel({
    required super.id,
    required super.name,
    required super.isSelected,
    required super.modifiedDate,
  });

  factory Wheel.anonymous() => Wheel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      isSelected: false,
      modifiedDate: DateTime.now());
}

class Quiz extends Game {
  const Quiz({
    required super.id,
    required super.name,
    required super.isSelected,
    required super.modifiedDate,
  });

  factory Quiz.anonymous() =>
      Quiz(id: '', name: '', isSelected: false, modifiedDate: DateTime.now());
}

extension GameTypeExtension on Game {
  String get gameType {
    switch (runtimeType) {
      case Wheel:
        return '轉盤遊戲';
      case Quiz:
        return '問答遊戲';
      default:
        return '';
    }
  }

  String get collectionName {
    switch (runtimeType) {
      case Wheel:
        return 'wheelData';
      case Quiz:
        return 'quizData';
      default:
        return '';
    }
  }

  String get typeName {
    switch (runtimeType) {
      case Wheel:
        return 'wheel';
      case Quiz:
      default:
        return 'quiz';
    }
  }
}
