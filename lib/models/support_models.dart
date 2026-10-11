class FaqModel {
  final int id;
  final String question;
  final String answer;
  final DateTime createdat;
  final DateTime updatedat;
  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdat,
    required this.updatedat,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      createdat: DateTime.parse(json['createdat']),
      updatedat: DateTime.parse(json['updatedat']),
    );
  }
}

class SupportContactsModel {
  final int id;
  final String name;
  final String value;
  final String type;
  final DateTime createdat;
  final DateTime updatedat;
  SupportContactsModel({
    required this.id,
    required this.name,
    required this.value,
    required this.type,
    required this.createdat,
    required this.updatedat,
  });
  factory SupportContactsModel.fromJson(Map<String, dynamic> json) {
    return SupportContactsModel(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      type: json['type'],
      createdat: DateTime.parse(json['createdat']),
      updatedat: DateTime.parse(json['updatedat']),
    );
  }
}
