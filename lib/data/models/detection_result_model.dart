import 'package:hive/hive.dart';

part 'detection_result_model.g.dart';

@HiveType(typeId: 0)
class DetectionResultModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final String diseaseName;

  @HiveField(3)
  final String diseaseScientific;

  @HiveField(4)
  final String diseaseType;

  @HiveField(5)
  final double confidence;

  @HiveField(6)
  final DateTime detectionTime;

  @HiveField(7)
  final String status;

  DetectionResultModel({
    required this.id,
    required this.imagePath,
    required this.diseaseName,
    required this.diseaseScientific,
    required this.diseaseType,
    required this.confidence,
    required this.detectionTime,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'diseaseName': diseaseName,
      'diseaseScientific': diseaseScientific,
      'diseaseType': diseaseType,
      'confidence': confidence,
      'detectionTime': detectionTime.toIso8601String(),
      'status': status,
    };
  }

  factory DetectionResultModel.fromJson(Map<String, dynamic> json) {
    return DetectionResultModel(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      diseaseName: json['diseaseName'] as String,
      diseaseScientific: json['diseaseScientific'] as String,
      diseaseType: json['diseaseType'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      detectionTime: DateTime.parse(json['detectionTime'] as String),
      status: json['status'] as String,
    );
  }

  DetectionResultModel copyWith({
    String? id,
    String? imagePath,
    String? diseaseName,
    String? diseaseScientific,
    String? diseaseType,
    double? confidence,
    DateTime? detectionTime,
    String? status,
  }) {
    return DetectionResultModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      diseaseName: diseaseName ?? this.diseaseName,
      diseaseScientific: diseaseScientific ?? this.diseaseScientific,
      diseaseType: diseaseType ?? this.diseaseType,
      confidence: confidence ?? this.confidence,
      detectionTime: detectionTime ?? this.detectionTime,
      status: status ?? this.status,
    );
  }
}
