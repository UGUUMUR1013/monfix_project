class Home {
  final String createdAt;
  final int entryId;
  final String temp;
  final String humi;

  const Home({
    required this.createdAt,
    required this.entryId,
    required this.temp,
    required this.humi,
  });

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
        createdAt: json['created_at'],
        entryId: json['entry_id'],
        temp: json['field1'],
        humi: json['field2']);
  }
}
