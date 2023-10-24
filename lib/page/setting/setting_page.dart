import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livestock/bloc/game/game_bloc.dart';
import 'package:livestock/bloc/game_data/game_data_bloc.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/page/setting/game_data_dialog.dart';
import 'package:livestock/page/setting/game_tile.dart';
import 'package:livestock/widget/general_background.dart';

enum SettingMode { list, edit }

class SettingPage extends HookWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<SettingMode> mode = useState<SettingMode>(SettingMode.list);
    final ValueNotifier<Game?> selectedGame = useValueNotifier<Game?>(null);

    useEffect(() {
      context.read<GameBloc>().add(GetGameListEvent());

      return;
    }, []);

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, gameState) {
        return Scaffold(
          appBar: AppBar(title: const Text('設定')),
          body: mode.value == SettingMode.list
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: gameState is GameListState
                              ? ListView.builder(
                                  itemCount: gameState.gameList.length,
                                  itemBuilder: (context, index) => GameTile(
                                    game: gameState.gameList[index],
                                    onTap: () {
                                      selectedGame.value = gameState.gameList[index];
                                      mode.value = SettingMode.edit;
                                    },
                                  ),
                                )
                              : const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      const GeneralBackground(),
                    ],
                  ),
                )
              : GameDataDialog(
                  game: selectedGame.value,
                  onFinished: () {
                    mode.value = SettingMode.list;
                    selectedGame.value = null;
                  },
                ),
          floatingActionButton: mode.value == SettingMode.list
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: FloatingActionButton(
                    tooltip: '新增遊戲',
                    backgroundColor: primaryGreen,
                    onPressed: () {
                      context.read<GameDataBloc>().add(ResetGameDataEvent());
                      mode.value = SettingMode.edit;
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
