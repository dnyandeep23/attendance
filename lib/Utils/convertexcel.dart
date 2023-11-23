import 'dart:io';
import 'package:attedance/Utils/attendanceModel.dart';
import 'package:attedance/Utils/customToast.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportStudentsToExcel(
    List<AttendanceData> students, double screenWidth) async {
  var excel = Excel.createExcel();
  var sheet = excel['Students'];
  DateTime now = DateTime.now();
  String date =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value =date;
  // Add headers
  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 2)).value =
      'Enrollment Number';
  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 2)).value =
      'First Name';
  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 2)).value =
      'Last Name';
  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 2)).value =
      'Status';

  for (int i = 1; i < students.length; i++) {
    var student = students[i];
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 2))
        .value = student.enrollment;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 2))
        .value = student.firstName;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 2))
        .value = student.lastName;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 2))
        .value = student.status;
  }

  final downloadDir = await getDownloadsDirectory();
  if (downloadDir != null) {
    DateTime now = DateTime.now();
    String date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final filepath = await FilePicker.platform.getDirectoryPath();
    final excelData = excel.encode();
    final fileName = 'attendance_$date.xlsx';
    final file = File('$filepath/$fileName');
    await file.writeAsBytes(excelData!);

    CustomToast(message: "$fileName/$fileName", screenwidth: screenWidth);


  } else {

  }
}
