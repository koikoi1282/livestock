import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livestock/bloc/game/game_bloc.dart';
import 'package:livestock/bloc/game_data/game_data_bloc.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/page/setting/editor/quiz_editor.dart';
import 'package:livestock/page/setting/editor/wheel_editor.dart';

class GameDataEditor extends HookWidget {
  final Game? game;
  final void Function() onFinished;

  const GameDataEditor({super.key, this.game, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    // Game
    final ValueNotifier<Game> gameNotifier = useValueNotifier<Game>(game ?? Wheel.anonymous());

    // Wheel
    final ValueNotifier<List<ValueNotifier<WheelData>>> wheelDatasNotifier = useValueNotifier([]);

    // Quiz
    final ValueNotifier<List<ValueNotifier<QuizData>>> quizDatasNotifier = useValueNotifier([]);

    final ValueNotifier<String> errorText = useValueNotifier<String>('');

    useEffect(() {
      if (game != null) {
        context.read<GameDataBloc>().add(LoadGameDataEvent(game: game!));
      }

      return;
    }, []);

    return BlocListener<GameDataBloc, GameDataState>(
      listener: (context, state) {
        if (state is DatasState) {
          if (game is Wheel) {
            wheelDatasNotifier.value =
                state.gameDatas.cast<WheelData>().map((data) => ValueNotifier<WheelData>(data)).toList();
          } else {
            quizDatasNotifier.value =
                state.gameDatas.cast<QuizData>().map((data) => ValueNotifier<QuizData>(data)).toList();
          }
        }
      },
      child: BlocBuilder<GameDataBloc, GameDataState>(
        bloc: context.read<GameDataBloc>(),
        builder: (context, state) {
          if (state is DataLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GameEditor(
                          isEdit: game != null,
                          selectedValue: game?.isSelected ?? false,
                          gameNotifier: gameNotifier,
                        ),
                        const SizedBox(height: 20),
                        ValueListenableBuilder<Game>(
                          valueListenable: gameNotifier,
                          builder: (context, game, child) {
                            if (game is Wheel) {
                              return WheelEditor(game: game, wheelDatasNotifier: wheelDatasNotifier);
                            }

                            return QuizEditor(game: game, quizDatasNotifier: quizDatasNotifier);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ValueListenableBuilder<String>(
                      valueListenable: errorText,
                      builder: (context, text, __) {
                        return Text(
                          text,
                          style:
                              TextStyle(color: Theme.of(context).inputDecorationTheme.errorStyle?.color ?? Colors.red),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: () => onFinished(),
                      child: const Text('取消'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        backgroundColor: primaryGreen,
                      ),
                      onPressed: () {
                        errorText.value = '';
                        if (formKey.currentState!.validate()) {
                          if (wheelDatasNotifier.value.length != wheelDataCount &&
                              quizDatasNotifier.value.length != quizDataCount) {
                            errorText.value = '請新增至合適的遊戲項目數量。';
                            return;
                          }

                          context.read<GameBloc>().add(SaveGameEvent(isNew: game == null, game: gameNotifier.value));

                          context.read<GameDataBloc>().add(SaveGameDataEvent(
                              game: gameNotifier.value,
                              gameDatas: gameNotifier.value is Wheel
                                  ? wheelDatasNotifier.value.map((dataNotifier) => dataNotifier.value).toList()
                                  : quizDatasNotifier.value.map((dataNotifier) => dataNotifier.value).toList()));

                          onFinished();
                        }
                      },
                      child: const Text(
                        '儲存',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GameEditor extends HookWidget {
  final bool isEdit;
  final bool selectedValue;
  final ValueNotifier<Game> gameNotifier;

  const GameEditor({
    super.key,
    required this.isEdit,
    required this.selectedValue,
    required this.gameNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<Type>> gameList = useMemoized(() => [
          DropdownMenuItem<Type>(
              value: Wheel,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(Wheel.anonymous().gameType),
              )),
          DropdownMenuItem<Type>(
              value: Quiz,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(Quiz.anonymous().gameType),
              )),
        ]);

    return ValueListenableBuilder<Game>(
      valueListenable: gameNotifier,
      builder: (context, game, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CellTitle(
                        title: '遊戲名稱',
                        message: '顯示在遊戲頁面上方的名稱',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        initialValue: game.name,
                        onChanged: (value) {
                          if (game is Wheel) {
                            gameNotifier.value = game.copy(name: value);
                          } else if (game is Quiz) {
                            gameNotifier.value = game.copy(name: value);
                          }
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '不可為空';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CellTitle(title: '遊戲種類'),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Theme.of(context).colorScheme.outline)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Type>(
                            value: game.runtimeType,
                            items: gameList,
                            onChanged: isEdit ? null : (value) => gameNotifier.value = game.changeType(),
                            isDense: true,
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CellTitle(
                        title: '選擇遊戲',
                        message: '如果想要更換選擇的遊戲，請至目標遊戲勾選',
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: game.isSelected,
                            onChanged: (value) {
                              if (!selectedValue) {
                                if (game is Wheel) {
                                  gameNotifier.value = game.copy(isSelected: value);
                                } else if (game is Quiz) {
                                  gameNotifier.value = game.copy(isSelected: value);
                                }
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text('設為選擇遊戲')
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CellTitle(
                        title: '客戶資料頁面標題',
                        message: '顯示在客戶資料頁面上方',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        initialValue: game.customerFormTitle,
                        onChanged: (value) {
                          if (game is Wheel) {
                            gameNotifier.value = game.copy(customerFormTitle: value);
                          } else if (game is Quiz) {
                            gameNotifier.value = game.copy(customerFormTitle: value);
                          }
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '不可為空';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CellTitle(
                        title: '客戶資料頁面副標題',
                        message: '顯示在客戶資料頁面上方',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        initialValue: game.customerFormSubtitle,
                        onChanged: (value) {
                          if (game is Wheel) {
                            gameNotifier.value = game.copy(customerFormSubtitle: value);
                          } else if (game is Quiz) {
                            gameNotifier.value = game.copy(customerFormSubtitle: value);
                          }
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '不可為空';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            if (game is Wheel)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CellTitle(
                          title: '轉盤頁面標題',
                          message: '顯示在轉盤頁面上方',
                        ),
                        TextFormField(
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          initialValue: game.wheelTitle,
                          onChanged: (value) => gameNotifier.value = game.copy(wheelTitle: value),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '不可為空';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CellTitle(
                          title: '獎勵頁面標題',
                          message: '顯示在獎勵頁面上方',
                        ),
                        TextFormField(
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          initialValue: game.priceTitle,
                          onChanged: (value) {
                            gameNotifier.value = game.copy(priceTitle: value);
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '不可為空';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )
            else if (game is Quiz)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CellTitle(
                          title: '選擇頁面標題',
                          message: '顯示在選擇頁面上方',
                        ),
                        TextFormField(
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          initialValue: game.selectionTitle,
                          onChanged: (value) => gameNotifier.value = game.copy(selectionTitle: value),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '不可為空';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CellTitle(
                          title: '選擇頁面副標題',
                          message: '顯示在選擇頁面上方',
                        ),
                        TextFormField(
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          initialValue: game.selectionSubtitle,
                          onChanged: (value) {
                            gameNotifier.value = game.copy(selectionSubtitle: value);
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '不可為空';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
          ],
        );
      },
    );
  }
}

class CellTitle extends StatelessWidget {
  final String title;
  final String? message;

  const CellTitle({super.key, required this.title, this.message});

  @override
  Widget build(BuildContext context) {
    Widget widget = Text(title);

    if (message == null) {
      return SizedBox(height: 24, child: widget);
    }

    return SizedBox(
      height: 24,
      child: Row(
        children: [
          widget,
          const SizedBox(width: 10),
          Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: message,
            child: const Icon(
              Icons.info_outline_rounded,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
