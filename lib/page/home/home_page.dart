import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/bloc/game/game_bloc.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/utils/hover_extension.dart';
import 'package:livestock/utils/image_utils.dart';
import 'package:livestock/widget/general_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget provimiWidget = AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: lightGray,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Image(image: imageMap['provimi']!),
        ),
      ),
    );

    Widget purinaWidget = AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: lightGray,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Image(image: imageMap['purina']!),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).go('/settings'),
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  return state is GameListState
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: state.selectedQuiz != null
                                    ? GestureDetector(
                                            onTap: () => GoRouter.of(context).push('/provimi'), child: provimiWidget)
                                        .showCursorOnHover
                                    : Opacity(
                                        opacity: 0.6,
                                        child: provimiWidget,
                                      ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: state.selectedWheel != null
                                    ? GestureDetector(
                                            onTap: () => GoRouter.of(context).push('/purina'), child: purinaWidget)
                                        .showCursorOnHover
                                    : Opacity(
                                        opacity: 0.6,
                                        child: purinaWidget,
                                      ),
                              ),
                            ],
                          ),
                        )
                      : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(height: 30),
            const GeneralBackground(),
          ],
        ),
      ),
    );
  }
}
