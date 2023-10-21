import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/data_provider/firebase_storage_provider.dart';
import 'package:livestock/page/setting/editor/game_data_editor.dart';

class QuizEditor extends StatelessWidget {
  final Game game;
  final ValueNotifier<List<ValueNotifier<QuizData>>> quizDatasNotifier;

  const QuizEditor({
    super.key,
    required this.game,
    required this.quizDatasNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('問答項目', style: TextStyle(fontSize: 20)),
        ValueListenableBuilder<List<ValueNotifier<QuizData>>>(
          valueListenable: quizDatasNotifier,
          builder: (context, quizDatas, _) {
            return Expanded(
              child: ListView(
                children: [
                  ...quizDatas.map((data) => QuizDataCard(
                      key: ValueKey(data.value.id),
                      onRemove: () => quizDatasNotifier.value = List.from(quizDatasNotifier.value)..remove(data),
                      quizData: data)),
                  if (quizDatas.length < quizDataCount)
                    IconButton(
                      style:
                          IconButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      onPressed: quizDatas.length < 2
                          ? () {
                              quizDatasNotifier.value = List.from(quizDatasNotifier.value)
                                ..add(ValueNotifier<QuizData>(QuizData.anonymous(game.id)));
                            }
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class QuizDataCard extends StatelessWidget {
  final ValueNotifier<QuizData> quizData;
  final void Function() onRemove;

  const QuizDataCard({super.key, required this.quizData, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CellTitle(
                        title: '名稱',
                        message: '問答首頁顯示名稱',
                      ),
                      ValueListenableBuilder<QuizData>(
                        valueListenable: quizData,
                        builder: (context, data, _) {
                          return TextFormField(
                            initialValue: data.name,
                            onChanged: (value) => quizData.value = data.copy(name: value),
                            maxLength: 10,
                            decoration: const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return '不可為空';
                              }

                              return null;
                            },
                          );
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
                      const CellTitle(title: '問答說明'),
                      ValueListenableBuilder<QuizData>(
                        valueListenable: quizData,
                        builder: (context, data, _) {
                          return TextFormField(
                            initialValue: data.description,
                            onChanged: (value) => quizData.value = data.copy(description: value),
                            maxLength: 200,
                            decoration: const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return '不可為空';
                              }

                              return null;
                            },
                          );
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
                      const CellTitle(title: '說明圖片'),
                      Row(
                        children: [
                          ValueListenableBuilder<QuizData>(
                            valueListenable: quizData,
                            builder: (context, data, __) {
                              return data.descriptionUrl?.isNotEmpty ?? false
                                  ? Image.network(
                                      data.descriptionUrl!,
                                      height: 60,
                                      cacheHeight: 60,
                                    )
                                  : Container(height: 60, alignment: Alignment.center, child: const Text('No Image'));
                            },
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () async {
                              FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'png'],
                              );

                              if (filePickerResult != null) {
                                await FirebaseStorageProvider.uploadFile(filePickerResult.files.first);

                                String imagePath = filePickerResult.files.first.name;

                                quizData.value = quizData.value.copy(
                                    imagePath: imagePath,
                                    descriptionUrl: await FirebaseStorageProvider.getFileUrlFromPath(imagePath));
                              }
                            },
                            icon: const Icon(Icons.file_upload_rounded),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CellTitle(title: '問題'),
                      ValueListenableBuilder<QuizData>(
                        valueListenable: quizData,
                        builder: (context, data, _) {
                          return TextFormField(
                            initialValue: data.quiz,
                            onChanged: (value) => quizData.value = data.copy(quiz: value),
                            maxLength: 10,
                            decoration: const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return '不可為空';
                              }

                              return null;
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CellTitle(title: '獎勵'),
                      ValueListenableBuilder<QuizData>(
                        valueListenable: quizData,
                        builder: (context, data, _) {
                          return TextFormField(
                            initialValue: data.price,
                            onChanged: (value) => quizData.value = data.copy(price: value),
                            maxLength: 10,
                            decoration: const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return '不可為空';
                              }

                              return null;
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CellTitle(title: '答案1'),
                      ValueListenableBuilder<QuizData>(
                        valueListenable: quizData,
                        builder: (context, data, _) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Radio<int>(
                                value: 0,
                                groupValue: data.answerIndex,
                                onChanged: (value) => quizData.value = data.copy(answerIndex: 0),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  initialValue: data.answers[0],
                                  onChanged: (value) =>
                                      quizData.value = data.copy(answers: List.from(data.answers)..[0] = value),
                                  maxLength: 10,
                                  decoration: const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return '不可為空';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          );
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
                      const CellTitle(title: '答案2'),
                      ValueListenableBuilder<QuizData>(
                        valueListenable: quizData,
                        builder: (context, data, _) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Radio<int>(
                                value: 1,
                                groupValue: data.answerIndex,
                                onChanged: (value) => quizData.value = data.copy(answerIndex: 1),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  initialValue: data.answers[1],
                                  onChanged: (value) =>
                                      quizData.value = data.copy(answers: List.from(data.answers)..[1] = value),
                                  maxLength: 10,
                                  decoration: const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return '不可為空';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          );
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
                      const CellTitle(title: '答案3'),
                      ValueListenableBuilder<QuizData>(
                        valueListenable: quizData,
                        builder: (context, data, _) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Radio<int>(
                                value: 2,
                                groupValue: data.answerIndex,
                                onChanged: (value) => quizData.value = data.copy(answerIndex: 2),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  initialValue: data.answers[2],
                                  onChanged: (value) =>
                                      quizData.value = data.copy(answers: List.from(data.answers)..[2] = value),
                                  maxLength: 10,
                                  decoration: const InputDecoration(border: OutlineInputBorder(), counterText: ''),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return '不可為空';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
