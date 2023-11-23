import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<void> createExcelFile(Map<String, dynamic> attendanceData) async {
  var excel = Excel.createExcel();
  var sheet = excel['Attendance'];
  var i = 1;
  var j = 1;
  var k = 4;
  // Add headers

  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 2)).value =
      'Enrollment Number';
  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 2)).value =
      'First Name';
  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 2)).value =
      'Last Name';

  Set<String> uniqueNames = {};

  attendanceData.forEach((date, records) {
    records.forEach((attendanceType, enrollmentStatus) {
      enrollmentStatus.forEach((enrollmentNo, stud) {
        if (!uniqueNames.contains(stud['EnrollmentNo'])) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 2))
              .value = stud['EnrollmentNo'];
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 2))
              .value = stud['FirstName'];
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 2))
              .value = stud['LastName'];
          uniqueNames.add(stud['EnrollmentNo']);
          i++;
        }
      });
    });
  });

  attendanceData.forEach((date, records) {
    j = 1;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: k, rowIndex: 2)).value =
        '$date';
    records.forEach((attendanceType, enrollmentStatus) {
      enrollmentStatus.forEach((enrollmentNo, stud) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: k, rowIndex: j + 2))
            .value = stud['status'];

        j++;
      });
    });
    k++;
  });

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

    // CustomToast(message: "$fileName/$fileName", screenwidth: screenWidth);

    // ignore: avoid_print
    print('Excel file saved to: $filepath');
  } else {
    // ignore: avoid_print
    print('Failed to access the download folder.');
  }
//   // Save the Excel file
}
