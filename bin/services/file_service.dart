import 'dart:convert';
import 'dart:io';

class FileService {
  final String filePath;

  FileService(this.filePath);

  Future<List<Map<String, dynamic>>?> readFile() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final content = await file.readAsString();
        return List<Map<String, dynamic>>.from(jsonDecode(content));
      }
    } on Exception catch (e) {
      print('Error reading file: $e');
    }
    return null;
  }

  Future<void> writeFile(List<Map<String, dynamic>> data) async {
    try {
      final file = File(filePath);
      await file.writeAsString(jsonEncode(data));
    } on Exception catch (e) {
      print('Error writing file: $e');
    }
  }
}
