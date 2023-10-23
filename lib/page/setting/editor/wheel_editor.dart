import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/data_provider/firebase_storage_provider.dart';
import 'package:livestock/page/setting/editor/game_data_editor.dart';

class WheelEditor extends StatelessWidget {
  final Game game;
  final ValueNotifier<List<ValueNotifier<WheelData>>> wheelDatasNotifier;

  const WheelEditor({
    super.key,
    required this.game,
    required this.wheelDatasNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '轉盤項目',
            style: TextStyle(fontSize: 20),
          ),
          ValueListenableBuilder<List<ValueNotifier<WheelData>>>(
            valueListenable: wheelDatasNotifier,
            builder: (context, wheelDatas, _) {
              return Column(
                children: [
                  ...wheelDatas.map((data) => WheelDataCard(
                      key: ValueKey(data.value.id),
                      onRemove: () => wheelDatasNotifier.value = List.from(wheelDatasNotifier.value)..remove(data),
                      wheelData: data)),
                  if (wheelDatas.length < wheelDataCount)
                    IconButton(
                      style:
                          IconButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      onPressed: wheelDatas.length < 6
                          ? () {
                              wheelDatasNotifier.value = List.from(wheelDatasNotifier.value)
                                ..add(ValueNotifier<WheelData>(WheelData.anonymous(game.id)));
                            }
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class WheelDataCard extends StatelessWidget {
  final ValueNotifier<WheelData> wheelData;
  final void Function() onRemove;

  const WheelDataCard({super.key, required this.wheelData, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CellTitle(title: '轉盤項目名稱'),
                  ValueListenableBuilder<WheelData>(
                    valueListenable: wheelData,
                    builder: (context, data, _) {
                      return TextFormField(
                        initialValue: data.name,
                        onChanged: (value) => wheelData.value = data.copy(name: value),
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
                  const CellTitle(title: '獎勵'),
                  ValueListenableBuilder<WheelData>(
                    valueListenable: wheelData,
                    builder: (context, data, _) {
                      return TextFormField(
                        initialValue: data.price,
                        onChanged: (value) => wheelData.value = data.copy(price: value),
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
                  const CellTitle(title: '轉盤圖片'),
                  Row(
                    children: [
                      ValueListenableBuilder<WheelData>(
                        valueListenable: wheelData,
                        builder: (context, data, __) {
                          return data.imageUrl?.isNotEmpty ?? false
                              ? Image.network(
                                  data.imageUrl!,
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

                            wheelData.value = wheelData.value.copy(
                                imagePath: imagePath,
                                imageUrl: await FirebaseStorageProvider.getFileUrlFromPath(imagePath));
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
      ),
    );
  }
}
