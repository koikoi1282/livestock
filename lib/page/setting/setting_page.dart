import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livestock/bloc/game/game_bloc.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/page/setting/game_data_dialog.dart';
import 'package:livestock/page/setting/game_tile.dart';
import 'package:livestock/widget/general_background.dart';

class SettingPage extends HookWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<GameBloc>().add(GetGameListEvent());

      return;
    }, []);

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, gameState) {
        return Scaffold(
          appBar: AppBar(title: const Text('設定')),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: gameState is GameListState
                        ? ListView.builder(
                            itemCount: gameState.gameList.length,
                            itemBuilder: (context, index) => GameTile(game: gameState.gameList[index]),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),
                const GeneralBackground(),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: FloatingActionButton(
              tooltip: '新增遊戲',
              backgroundColor: primaryGreen,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const GameDataDialog(),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
