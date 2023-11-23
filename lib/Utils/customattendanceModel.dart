class CustomAttendanceModel {
  late String enrollmentNo;
  late String firstName;
  late String lastName;
  late String status;
  late String date; // Date stored as a string

  CustomAttendanceModel({
    required this.enrollmentNo,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'EnrollmentNo': enrollmentNo,
      'FirstName': firstName,
      'LastName': lastName,
      'Status': status,
      'Date': date,
    };
  }

  factory CustomAttendanceModel.fromJson(Map<String, dynamic> json) {
    return CustomAttendanceModel(
      enrollmentNo: json['EnrollmentNo'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      status: json['Status'],
      date: json['Date'],
    );
  }
}
