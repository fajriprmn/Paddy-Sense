import 'package:hive/hive.dart';
import '../models/detection_result_model.dart';

class LocalDataSource {
  static const String _boxName = 'detections';
  
  Box<DetectionResultModel> _getBox() {
    return Hive.box<DetectionResultModel>(_boxName);
  }

  Future<void> saveDetection(DetectionResultModel detection) async {
    final box = _getBox();
    await box.put(detection.id, detection);
  }

  List<DetectionResultModel> getAllDetections() {
  final box = _getBox();
  return box.values.toList()
    ..sort((a, b) => b.detectionTime.compareTo(a.detectionTime));
}

  Future<List<DetectionResultModel>> getDetectionsByStatus(String status) async {
    final box = _getBox();
    return box.values
        .where((detection) => detection.status == status)
        .toList()
      ..sort((a, b) => b.detectionTime.compareTo(a.detectionTime));
  }

  Future<List<DetectionResultModel>> getDetectionsByDiseaseType(String diseaseType) async {
    final box = _getBox();
    return box.values
        .where((detection) => detection.diseaseType == diseaseType)
        .toList()
      ..sort((a, b) => b.detectionTime.compareTo(a.detectionTime));
  }

  Future<DetectionResultModel?> getDetectionById(String id) async {
    final box = _getBox();
    return box.get(id);
  }

  Future<void> deleteDetection(String id) async {
    final box = _getBox();
    await box.delete(id);
  }

  Future<void> deleteMultipleDetections(List<String> ids) async {
    final box = _getBox();
    await box.deleteAll(ids);
  }

  Future<void> clearAllDetections() async {
    final box = _getBox();
    await box.clear();
  }

  Future<Map<String, int>> getStatistics() async {
    final box = _getBox();
    final allDetections = box.values.toList();
    
    final totalScan = allDetections.length;
    final healthy = allDetections.where((d) => d.status == 'healthy').length;
    final diseased = allDetections.where((d) => d.status == 'diseased').length;
    
    return {
      'totalScan': totalScan,
      'healthy': healthy,
      'diseased': diseased,
    };
  }
}
