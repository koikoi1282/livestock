import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livestock/bloc/game/game_bloc.dart';
import 'package:livestock/bloc/game_data/game_data_bloc.dart';
import 'package:livestock/bloc/result/result_bloc.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/data_model/customer_data.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/page/provimi/provimi_dialog.dart';
import 'package:livestock/utils/hover_extension.dart';
import 'package:livestock/widget/customer_form.dart';

enum ProvimiStage { customerForm, selection, info, question }

class ProvimiPage extends HookWidget {
  const ProvimiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<ProvimiStage> provimiStage = useState(ProvimiStage.customerForm);
    final ValueNotifier<QuizData?> selectedGameData = useValueNotifier<QuizData?>(null);
    final ObjectRef<CustomerData?> customerData = useRef(null);

    useEffect(() {
      context
          .read<GameDataBloc>()
          .add(LoadGameDataEvent(game: (context.read<GameBloc>().state as GameListState).selectedQuiz!));

      return;
    }, []);

    return Theme(
      data: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(errorStyle: TextStyle(fontSize: 10)),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue, background: Colors.white, error: Colors.red),
        useMaterial3: true,
      ),
      child: BlocBuilder<GameDataBloc, GameDataState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 140,
              title: Row(
                children: [
                  Image.asset(
                    'assets/provimi.png',
                    width: 300,
                    cacheWidth: 300,
                  ),
                  const SizedBox(width: 30),
                  if (provimiStage.value == ProvimiStage.customerForm) ...[
                    const Text(
                      '歡迎參加 嘉吉台灣 普樂諾頓產品問答遊戲',
                      style: TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      '填寫資料即可參加',
                    )
                  ],
                ],
              ),
              backgroundColor: Colors.transparent,
            ),
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, bottom: 10),
                    child: Image.asset(
                      'assets/cargill_logo.png',
                      width: 150,
                      cacheWidth: 150,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/provimi_dot.png',
                    width: 200,
                    cacheWidth: 200,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    'assets/provimi_color.png',
                    width: 380,
                    cacheWidth: 380,
                  ),
                ),
                state is DatasState
                    ? Center(
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(top: 180),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: () {
                            switch (provimiStage.value) {
                              case ProvimiStage.customerForm:
                                return CustomerForm(
                                  primaryColor: primaryBlue,
                                  onNext: (data) {
                                    provimiStage.value = ProvimiStage.selection;
                                    customerData.value = data;
                                  },
                                );

                              case ProvimiStage.selection:
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '黴菌毒素對於禽畜的生長影響非常大，讓我們來看看...',
                                      style: TextStyle(color: primaryBlue, fontSize: 36),
                                    ),
                                    const Text(
                                      '您對哪個畜種比較有興趣呢？',
                                      style: TextStyle(color: primaryGreen, fontSize: 24),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            selectedGameData.value = state.gameDatas.first as QuizData;
                                            provimiStage.value = ProvimiStage.info;
                                          },
                                          child: Stack(
                                            children: [
                                              Image.asset(
                                                'assets/provimi_pig.png',
                                                height: 250,
                                                cacheHeight: 250,
                                              ),
                                              Positioned.fill(
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(bottom: 60),
                                                    child: Text(
                                                      state.gameDatas.first.name,
                                                      style: const TextStyle(color: Colors.white, fontSize: 40),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ).showCursorOnHover,
                                        const SizedBox(width: 40),
                                        GestureDetector(
                                          onTap: () {
                                            selectedGameData.value = state.gameDatas.last as QuizData;
                                            provimiStage.value = ProvimiStage.info;
                                          },
                                          child: Stack(
                                            children: [
                                              Image.asset(
                                                'assets/provimi_chicken.png',
                                                height: 300,
                                                cacheHeight: 300,
                                              ),
                                              Positioned.fill(
                                                child: Center(
                                                  child: Text(
                                                    state.gameDatas.last.name,
                                                    style: const TextStyle(color: Colors.white, fontSize: 40),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ).showCursorOnHover,
                                      ],
                                    ),
                                  ],
                                );
                              case ProvimiStage.info:
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '黴菌毒素對於禽畜的生長影響非常大，讓我們來看看...',
                                      style: TextStyle(color: primaryBlue, fontSize: 36),
                                    ),
                                    Text(
                                      '不同黴菌毒素在${selectedGameData.value!.name}體內累積後的中毒症狀',
                                      style: const TextStyle(color: primaryGreen, fontSize: 24),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Expanded(
                                          flex: 3,
                                          child: Image.network(selectedGameData.value!.descriptionUrl!),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            selectedGameData.value!.description,
                                            style: const TextStyle(color: primaryBlue, fontSize: 24),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        ),
                                        onPressed: () => provimiStage.value = ProvimiStage.question,
                                        child: const Text('前往回答'),
                                      ),
                                    ),
                                  ],
                                );
                              case ProvimiStage.question:
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '看完了黴菌毒素對${selectedGameData.value!.name}的影響...',
                                      style: const TextStyle(color: primaryBlue, fontSize: 36),
                                    ),
                                    const Text(
                                      '請您回答下列問題，即可獲得精美獎品',
                                      style: TextStyle(color: primaryGreen, fontSize: 24),
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      selectedGameData.value!.quiz,
                                      style: const TextStyle(color: primaryBlue, fontSize: 24),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 80,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) => ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: const Size(300, 80),
                                                    elevation: 4,
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                    backgroundColor: primaryBlue),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return ProvimiDialog(
                                                        isCorrect: selectedGameData.value!.answerIndex == index,
                                                        price: selectedGameData.value!.price,
                                                      );
                                                    },
                                                  ).then((value) {
                                                    if (selectedGameData.value!.answerIndex == index) {
                                                      context.read<ResultBloc>().add(AddResultEvent(
                                                          game: (context.read<GameBloc>().state as GameListState)
                                                              .selectedQuiz!,
                                                          customerData: customerData.value!,
                                                          gameData: selectedGameData.value!));
                                                      provimiStage.value = ProvimiStage.customerForm;
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  selectedGameData.value!.answers[index],
                                                  style: const TextStyle(color: Colors.white, fontSize: 24),
                                                ),
                                              ),
                                          separatorBuilder: (context, index) => const SizedBox(width: 20),
                                          itemCount: selectedGameData.value!.answers.length),
                                    ),
                                  ],
                                );
                            }
                          }(),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
