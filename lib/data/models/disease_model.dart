class DiseaseModel {
  final String id;
  final String nameId;
  final String nameLatin;
  final String type;
  final String description;
  final String symptoms;
  final String treatment;
  final String prevention;

  DiseaseModel({
    required this.id,
    required this.nameId,
    required this.nameLatin,
    required this.type,
    required this.description,
    required this.symptoms,
    required this.treatment,
    required this.prevention,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameId': nameId,
      'nameLatin': nameLatin,
      'type': type,
      'description': description,
      'symptoms': symptoms,
      'treatment': treatment,
      'prevention': prevention,
    };
  }

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id'] as String,
      nameId: json['nameId'] as String,
      nameLatin: json['nameLatin'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      symptoms: json['symptoms'] as String,
      treatment: json['treatment'] as String,
      prevention: json['prevention'] as String,
    );
  }
}
