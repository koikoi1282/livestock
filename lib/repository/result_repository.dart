import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:livestock/data_model/customer_data.dart';
import 'package:livestock/data_model/game.dart';
import 'package:livestock/data_model/game_data.dart';
import 'package:livestock/data_provider/firestore_provider.dart';

class ResultRepository {
  Future<void> addResult(Game game, CustomerData customerData, GameData gameData) async {
    await FirestoreProvider.addResult(game.id, customerData, gameData.price);
  }

  Future<void> downloadResult(Game game) async {
    Excel excel = Excel.createExcel();
    Sheet sheet = excel.sheets.values.first;
    sheet.appendRow(['姓名', '產業性質', '區域位置', '聯絡資訊', '獎品']);

    List<QueryDocumentSnapshot<Map<String, dynamic>>> resultSnapshots = await FirestoreProvider.getResults(game.id);

    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in resultSnapshots) {
      sheet.appendRow([
        snapshot.data()['name'],
        snapshot.data()['industrialNature'],
        snapshot.data()['location'],
        snapshot.data()['contactInformation'],
        snapshot.data()['price']
      ]);
    }

    excel.save(fileName: '${game.name}_${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}.xlsx');
  }

  Future<void> deleteResultByGameId(Game game) async => await FirestoreProvider.deleteResultByGameId(game.id);
}
