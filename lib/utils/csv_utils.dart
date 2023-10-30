import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class CsvUtils {
  static Future<List<List<dynamic>>> openAndProcessCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String csvContent = String.fromCharCodes(file.bytes!);

      // Process the CSV content here (e.g., parse and display it)
      List<List<dynamic>> csvTable = const CsvToListConverter(
        fieldDelimiter: ';',
        convertEmptyTo: '',
      ).convert(csvContent);
      return csvTable; // Retorne a lista de dados
    }

    return []; // Retorna uma lista vazia se nenhum arquivo foi escolhido
  }
}
