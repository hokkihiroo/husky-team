import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

Future<File> downloadPdf(String pdfFileName) async {
  final storageRef = FirebaseStorage.instance.ref().child('pdfs/$pdfFileName');
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/$pdfFileName';

  final File file = File(filePath);

  if (!file.existsSync()) {
    await storageRef.writeToFile(file); // Firebase Storage에서 다운로드
  }

  return file;
}
