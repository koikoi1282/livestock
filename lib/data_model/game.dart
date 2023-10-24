import 'package:equatable/equatable.dart';

abstract class Game extends Equatable {
  final String id;
  final String name;
  final bool isSelected;
  final String customerFormTitle;
  final String customerFormSubtitle;
  final DateTime modifiedDate;

  const Game({
    required this.id,
    required this.name,
    required this.isSelected,
    required this.customerFormTitle,
    required this.customerFormSubtitle,
    required this.modifiedDate,
  });

  factory Game.fromDbJson(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'wheel':
        return Wheel(
          id: map['id'],
          name: map['name'],
          isSelected: map['isSelected'],
          customerFormTitle: map['customerFormTitle'],
          customerFormSubtitle: map['customerFormSubtitle'],
          modifiedDate: DateTime.fromMillisecondsSinceEpoch(map['modifiedDate']),
          wheelTitle: map['wheelTitle'],
          priceTitle: map['priceTitle'],
        );
      case 'quiz':
      default:
        return Quiz(
          id: map['id'],
          name: map['name'],
          isSelected: map['isSelected'],
          customerFormTitle: map['customerFormTitle'],
          customerFormSubtitle: map['customerFormSubtitle'],
          modifiedDate: DateTime.fromMillisecondsSinceEpoch(map['modifiedDate']),
          selectionTitle: map['selectionTitle'],
          selectionSubtitle: map['selectionSubtitle'],
        );
    }
  }

  Game changeType() {
    if (this is Wheel) {
      return Quiz(
          id: id,
          name: name,
          isSelected: isSelected,
          customerFormTitle: customerFormTitle,
          customerFormSubtitle: customerFormSubtitle,
          modifiedDate: modifiedDate,
          selectionTitle: '',
          selectionSubtitle: '');
    }

    return Wheel(
        id: id,
        name: name,
        isSelected: isSelected,
        customerFormTitle: customerFormTitle,
        customerFormSubtitle: customerFormSubtitle,
        modifiedDate: modifiedDate,
        wheelTitle: '',
        priceTitle: '');
  }

  @override
  List<Object?> get props => [id, name, isSelected, customerFormTitle, customerFormSubtitle, modifiedDate];
}

class Wheel extends Game {
  final String wheelTitle;
  final String priceTitle;

  const Wheel({
    required super.id,
    required super.name,
    required super.isSelected,
    required super.customerFormTitle,
    required super.customerFormSubtitle,
    required super.modifiedDate,
    required this.wheelTitle,
    required this.priceTitle,
  });

  factory Wheel.anonymous() => Wheel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      isSelected: false,
      customerFormTitle: '',
      customerFormSubtitle: '',
      modifiedDate: DateTime.now(),
      wheelTitle: '',
      priceTitle: '');

  Wheel copy({
    String? id,
    String? name,
    bool? isSelected,
    String? customerFormTitle,
    String? customerFormSubtitle,
    DateTime? modifiedDate,
    String? wheelTitle,
    String? priceTitle,
  }) {
    return Wheel(
        id: id ?? this.id,
        name: name ?? this.name,
        isSelected: isSelected ?? this.isSelected,
        customerFormTitle: customerFormTitle ?? this.customerFormTitle,
        customerFormSubtitle: customerFormSubtitle ?? this.customerFormSubtitle,
        modifiedDate: modifiedDate ?? this.modifiedDate,
        wheelTitle: wheelTitle ?? this.wheelTitle,
        priceTitle: priceTitle ?? this.priceTitle);
  }

  Map<String, dynamic> toDbJson() => {
        'name': name,
        'type': typeName,
        'isSelected': isSelected,
        'customerFormTitle': customerFormTitle,
        'customerFormSubtitle': customerFormSubtitle,
        'modifiedDate': modifiedDate.millisecondsSinceEpoch,
        'wheelTitle': wheelTitle,
        'priceTitle': priceTitle,
      };

  @override
  List<Object?> get props => [...super.props, wheelTitle, priceTitle];
}

class Quiz extends Game {
  final String selectionTitle;
  final String selectionSubtitle;

  const Quiz({
    required super.id,
    required super.name,
    required super.isSelected,
    required super.customerFormTitle,
    required super.customerFormSubtitle,
    required super.modifiedDate,
    required this.selectionTitle,
    required this.selectionSubtitle,
  });

  factory Quiz.anonymous() => Quiz(
      id: '',
      name: '',
      isSelected: false,
      customerFormTitle: '',
      customerFormSubtitle: '',
      modifiedDate: DateTime.now(),
      selectionTitle: '',
      selectionSubtitle: '');

  Quiz copy({
    String? id,
    String? name,
    bool? isSelected,
    String? customerFormTitle,
    String? customerFormSubtitle,
    DateTime? modifiedDate,
    String? selectionTitle,
    String? selectionSubtitle,
  }) {
    return Quiz(
        id: id ?? this.id,
        name: name ?? this.name,
        isSelected: isSelected ?? this.isSelected,
        customerFormTitle: customerFormTitle ?? this.customerFormTitle,
        customerFormSubtitle: customerFormSubtitle ?? this.customerFormSubtitle,
        modifiedDate: modifiedDate ?? this.modifiedDate,
        selectionTitle: selectionTitle ?? this.selectionTitle,
        selectionSubtitle: selectionSubtitle ?? this.selectionSubtitle);
  }

  Map<String, dynamic> toDbJson() => {
        'name': name,
        'type': typeName,
        'isSelected': isSelected,
        'customerFormTitle': customerFormTitle,
        'customerFormSubtitle': customerFormSubtitle,
        'modifiedDate': modifiedDate.millisecondsSinceEpoch,
        'selectionTitle': selectionTitle,
        'selectionSubtitle': selectionSubtitle,
      };

  @override
  List<Object?> get props => [...super.props, selectionTitle, selectionSubtitle];
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
