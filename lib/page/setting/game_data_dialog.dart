import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/page/setting/editor/game_data_editor.dart';

class GameDataDialog extends HookWidget {
  final Game? game;
  const GameDataDialog({super.key, this.game});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(game?.name != null ? '編輯遊戲' : '新增遊戲'),
      backgroundColor: Colors.white,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.9,
        child: GameDataEditor(game: game),
      ),
    );
  }
}
