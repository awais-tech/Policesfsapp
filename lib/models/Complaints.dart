class ComplaintsModel {
  final String category;
  final String subcategory;
  final String title;
  final String description;
  final String complaintno;
  final String type;
  final String sentby;
  String status = 'pending';
  final DateTime date;
  final String policeStationName;
  final String? policeOfficerName;

  ComplaintsModel({
    required this.category,
    required this.subcategory,
    required this.title,
    required this.description,
    required this.complaintno,
    required this.type,
    required this.status,
    required this.sentby,
    required this.date,
    required this.policeStationName,
    required this.policeOfficerName,
  });
}
