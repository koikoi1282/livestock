import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock/bloc/game/game_bloc.dart';
import 'package:livestock/bloc/game_data/game_data_bloc.dart';
import 'package:livestock/bloc/result/result_bloc.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/utils/hover_extension.dart';

class GameTile extends StatelessWidget {
  final Game game;
  final void Function() onTap;

  const GameTile({super.key, required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: game.isSelected
          ? const Tooltip(triggerMode: TooltipTriggerMode.tap, message: '目前選擇遊戲', child: Icon(Icons.star))
          : const SizedBox(width: 24),
      title: Text(game.name),
      subtitle: Text(game.gameType),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.file_download_rounded),
            tooltip: '下載客戶資料',
            onPressed: () => context.read<ResultBloc>().add(DownloadResultEvent(game: game)),
          ),
          IconButton(
              tooltip: '刪除遊戲',
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('確定要刪除遊戲嗎？'),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('取消'),
                        ),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('確定'),
                        ),
                      ],
                    );
                  },
                ).then((value) {
                  if (value ?? false) {
                    context.read<GameBloc>().add(DeleteGameEvent(gameId: game.id));
                    context.read<GameDataBloc>().add(DeleteGameDatasByGameId(game: game));
                    context.read<ResultBloc>().add(DeleteResultByGameId(game: game));
                  }
                });
              },
              icon: const Icon(Icons.delete_outline_rounded)),
        ],
      ),
      onTap: () {
        onTap();
        // showDialog(
        //   context: context,
        //   builder: (context) => GameDataDialog(game: game),
        // );
      },
    ).showCursorOnHover;
  }
}
