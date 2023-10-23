import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livestock/bloc/game/game_bloc.dart';
import 'package:livestock/bloc/game_data/game_data_bloc.dart';
import 'package:livestock/bloc/result/result_bloc.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/data_model/customer_data.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/page/purina/wheel.dart';
import 'package:livestock/utils/image_utils.dart';
import 'package:livestock/widget/customer_form.dart';
import 'package:livestock/widget/general_background.dart';

enum PurinaStage { customerForm, wheel }

class PurinaPage extends HookWidget {
  const PurinaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<PurinaStage> purinaStage = useState(PurinaStage.customerForm);
    final ObjectRef<CustomerData?> customerData = useRef<CustomerData?>(null);
    final ValueNotifier<ui.Image?> wheelImage = useState<ui.Image?>(null);
    final ValueNotifier<List<ui.Image>?> imageList = useState(null);

    void loadImage() async {
      final ByteData assetImageByteData = await rootBundle.load('assets/purina_wheel.png');
      final codec = await ui.instantiateImageCodec(
        assetImageByteData.buffer.asUint8List(),
        targetHeight: 500,
        targetWidth: 500,
      );
      wheelImage.value = (await codec.getNextFrame()).image;
    }

    useEffect(() {
      context
          .read<GameDataBloc>()
          .add(LoadGameDataEvent(game: (context.read<GameBloc>().state as GameListState).selectedWheel!));

      loadImage();

      return () => wheelImage.value?.dispose();
    }, []);

    return Theme(
      data: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(errorStyle: TextStyle(fontSize: 10)),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryRed, background: Colors.white, error: Colors.red),
        useMaterial3: true,
      ),
      child: BlocListener<GameDataBloc, GameDataState>(
        listener: (context, state) {
          if (state is DatasState) {
            Future<ui.Image> getImage(String path) async {
              var completer = Completer<ImageInfo>();
              var img = NetworkImage(path);
              img.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
                completer.complete(info);
              }));
              ImageInfo imageInfo = await completer.future;

              return imageInfo.image;
            }

            void getImages() async {
              imageList.value = [];
              for (WheelData wheelData in state.gameDatas.cast<WheelData>()) {
                imageList.value = List.from(imageList.value!)..add(await getImage(wheelData.imageUrl!));
              }
            }

            getImages();
          }
        },
        child: BlocBuilder<GameDataBloc, GameDataState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: primaryRed,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                toolbarHeight: 140,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      color: Colors.white,
                      child: Image(
                        image: imageMap['purina']!,
                        width: 200,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        if (purinaStage.value == PurinaStage.customerForm) ...[
                          const Text(
                            '歡迎參加 嘉吉台灣普瑞納產品抽獎',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            '填寫資料即可參加',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                        if (purinaStage.value == PurinaStage.wheel)
                          const Text(
                            '請轉動轉盤，回答產品特色即可獲得贈品',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              resizeToAvoidBottomInset: false,
              body: Container(
                decoration:
                    BoxDecoration(image: DecorationImage(image: imageMap['purinaBackground']!, fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: GeneralBackground(onlyLogo: true),
                      ),
                    ),
                    state is DatasState
                        ? Center(
                            child: Container(
                              alignment: Alignment.topCenter,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: () {
                                switch (purinaStage.value) {
                                  case PurinaStage.customerForm:
                                    return Center(
                                      child: CustomerForm(
                                        primaryColor: primaryRed,
                                        onNext: (data) {
                                          purinaStage.value = PurinaStage.wheel;
                                          customerData.value = data;
                                        },
                                      ),
                                    );

                                  case PurinaStage.wheel:
                                    return wheelImage.value != null && imageList.value!.length == 6
                                        ? Center(
                                            child: WheelComponent(
                                              wheelDatas: state.gameDatas.cast<WheelData>(),
                                              wheelImage: wheelImage.value!,
                                              imageList: imageList.value!,
                                              onFinish: (selectedIndex) {
                                                context.read<ResultBloc>().add(AddResultEvent(
                                                    game: (context.read<GameBloc>().state as GameListState)
                                                        .selectedWheel!,
                                                    customerData: customerData.value!,
                                                    gameData: state.gameDatas.cast<WheelData>()[selectedIndex]));
                                                purinaStage.value = PurinaStage.customerForm;
                                              },
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                }
                              }(),
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
