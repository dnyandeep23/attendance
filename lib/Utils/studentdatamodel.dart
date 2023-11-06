class StudentLocation {
  String studentId;
  String firstName;
  String lastName;
  double latitude;
  double longitude;

  StudentLocation({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'StudentLocation{studentId: $studentId, firstName: $firstName, lastName: $lastName, latitude: $latitude, longitude: $longitude}';
  }
}
