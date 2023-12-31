import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livestock/bloc/game/game_bloc.dart';
import 'package:livestock/bloc/game_data/game_data_bloc.dart';
import 'package:livestock/bloc/result/result_bloc.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/data_model/customer_data.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/page/provimi/provimi_dialog.dart';
import 'package:livestock/utils/hover_extension.dart';
import 'package:livestock/utils/image_utils.dart';
import 'package:livestock/widget/customer_form.dart';
import 'package:livestock/widget/general_background.dart';

enum ProvimiStage { customerForm, selection, info, question }

class ProvimiPage extends HookWidget {
  const ProvimiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<ProvimiStage> provimiStage = useState(ProvimiStage.customerForm);
    final ValueNotifier<QuizData?> selectedGameData = useValueNotifier<QuizData?>(null);
    final ObjectRef<CustomerData?> customerData = useRef(null);
    final ObjectRef<Quiz> selectedQuiz = useRef((context.read<GameBloc>().state as GameListState).selectedQuiz!);

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
              backgroundColor: Colors.transparent,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 140,
              title: Row(
                children: [
                  Image(
                    image: imageMap['provimi']!,
                    width: 300,
                  ),
                  const SizedBox(width: 30),
                  if (provimiStage.value == ProvimiStage.customerForm) ...[
                    Text(
                      selectedQuiz.value.customerFormTitle,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 15),
                    Text(selectedQuiz.value.customerFormSubtitle)
                  ],
                ],
              ),
            ),
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: GeneralBackground(onlyLogo: true),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Image(
                    image: imageMap['provimiDot']!,
                    width: 200,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image(
                    image: imageMap['provimiColor']!,
                    width: 200,
                  ),
                ),
                state is DatasState
                    ? SingleChildScrollView(
                        child: Center(
                          child: Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(top: 160),
                            width: MediaQuery.of(context).size.width * 0.9,
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
                                      Text(
                                        selectedQuiz.value.selectionTitle,
                                        style: const TextStyle(color: primaryBlue, fontSize: 36),
                                      ),
                                      Text(
                                        selectedQuiz.value.selectionSubtitle,
                                        style: const TextStyle(color: primaryGreen, fontSize: 24),
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
                                                Image(
                                                  image: imageMap['provimiPig']!,
                                                  height: 250,
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
                                                Image(
                                                  image: imageMap['provimiChicken']!,
                                                  height: 300,
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
                                      Text(
                                        selectedGameData.value!.descriptionTitle,
                                        style: const TextStyle(color: primaryBlue, fontSize: 36),
                                      ),
                                      Text(
                                        selectedGameData.value!.descriptionSubtitle,
                                        style: const TextStyle(color: primaryGreen, fontSize: 24),
                                      ),
                                      const SizedBox(height: 30),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Image.network(selectedGameData.value!.descriptionUrl!),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  selectedGameData.value!.description,
                                                  style: const TextStyle(color: primaryBlue, fontSize: 24),
                                                ),
                                                const SizedBox(height: 30),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                    backgroundColor: primaryBlue,
                                                    fixedSize: const Size(200, 60),
                                                  ),
                                                  onPressed: () => provimiStage.value = ProvimiStage.question,
                                                  child: const Text(
                                                    '前往回答',
                                                    style: TextStyle(fontSize: 24, color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                case ProvimiStage.question:
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedGameData.value!.quizTitle,
                                        style: const TextStyle(color: primaryBlue, fontSize: 36),
                                      ),
                                      Text(
                                        selectedGameData.value!.quizSubtitle,
                                        style: const TextStyle(color: primaryGreen, fontSize: 24),
                                      ),
                                      const SizedBox(height: 30),
                                      Text(
                                        selectedGameData.value!.quiz,
                                        style: const TextStyle(color: primaryBlue, fontSize: 24),
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        height: 80,
                                        child: Row(
                                          children: selectedGameData.value!.answers
                                              .mapIndexed(
                                                (index, element) => Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        minimumSize: const Size(200, 80),
                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(4)),
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
                                                      element,
                                                      style: const TextStyle(color: Colors.white, fontSize: 24),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  );
                              }
                            }(),
                          ),
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
