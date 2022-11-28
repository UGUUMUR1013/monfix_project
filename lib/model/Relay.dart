class Relay {
  final String createdAt;
  final String entryId;
  final String rel1;
  final String rel2;

  const Relay({
    required this.createdAt,
    required this.entryId,
    required this.rel1,
    required this.rel2,
  });

  factory Relay.fromJson(Map<String, dynamic> json) {
    return Relay(
      createdAt: json['created_at'],
      entryId: json['entry_id'],
      rel1: json['field1'] ?? '0',
      rel2: json['field2'] ?? '0',
    );
  }
}
