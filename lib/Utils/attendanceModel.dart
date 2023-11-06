class AttendanceData {
  String enrollment;
  String firstName;
  String lastName;
  String status;
  String date;


  AttendanceData({
    required this.enrollment,
    required this.firstName,
     required this.lastName,
     required this.status,
      required this.date,
  });

  @override
  String toString() {
    return 'StudentLocation{studentId: $enrollment, firstName: $firstName, ';
    // lastName: $lastName, latitude: $present}
  }
}
