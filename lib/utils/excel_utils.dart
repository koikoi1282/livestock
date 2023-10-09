import 'package:excel/excel.dart';

class ExcelUtils {
  static const fileName = 'livestock.xlsx';
  static late Excel excel;
  static late Sheet sheet;

  static Future<void> init() async {
    excel = Excel.createExcel();
    sheet = excel.sheets.values.first;
    sheet.appendRow(['This', 'is', 'some', 'column', 'name']);
  }

  static void addNewColumn(List<String> data) {
    sheet.appendRow(data);
  }

  static void saveFile() {
    excel.save(fileName: fileName);
  }
}
