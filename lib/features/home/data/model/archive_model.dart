class ArchiveData {
  final String date;
  final int id;

  ArchiveData({required this.date, required this.id});

  factory ArchiveData.fromJson(Map<String, dynamic> json) {
    return ArchiveData(
      date: json['date'],
      id: json['id'],
    );
  }
}
