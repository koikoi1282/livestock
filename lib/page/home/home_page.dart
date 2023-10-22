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
    Widget provimiWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: lightGray,
      ),
      alignment: Alignment.center,
      height: 500,
      width: 500,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        height: 480,
        width: 480,
        child: Image(
          image: imageMap['provimi']!,
          width: 400,
        ),
      ),
    );

    Widget purinaWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: lightGray,
      ),
      alignment: Alignment.center,
      height: 500,
      width: 500,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        height: 480,
        width: 480,
        child: Image(
          image: imageMap['purina']!,
          width: 400,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push('/settings'),
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
                              state.selectedQuiz != null
                                  ? GestureDetector(
                                          onTap: () => GoRouter.of(context).push('/provimi'), child: provimiWidget)
                                      .showCursorOnHover
                                  : Opacity(
                                      opacity: 0.6,
                                      child: provimiWidget,
                                    ),
                              const SizedBox(width: 20),
                              state.selectedWheel != null
                                  ? GestureDetector(
                                          onTap: () => GoRouter.of(context).push('/purina'), child: purinaWidget)
                                      .showCursorOnHover
                                  : Opacity(
                                      opacity: 0.6,
                                      child: purinaWidget,
                                    ),
                            ],
                          ),
                        )
                      : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const GeneralBackground(),
          ],
        ),
      ),
    );
  }
}
