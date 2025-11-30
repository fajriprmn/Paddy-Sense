import 'dart:io';
import 'package:uuid/uuid.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../datasources/disease_data_source.dart';
import '../models/detection_result_model.dart';
import '../models/disease_model.dart';

class DetectionRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final DiseaseDataSource diseaseDataSource;

  DetectionRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.diseaseDataSource,
  });

  Future<DetectionResultModel> detectDisease(File imageFile) async {
    // Get prediction from API
    final prediction = await remoteDataSource.predictDisease(imageFile);
    
    if (prediction.predictions.isEmpty) {
      throw Exception('No prediction result');
    }

    // Get top prediction
    final topPrediction = prediction.predictions.first;
    
    // Map label to disease
    final disease = _mapLabelToDisease(topPrediction.label);
    
    // Create detection result
    final result = DetectionResultModel(
      id: const Uuid().v4(),
      imagePath: imageFile.path,
      diseaseName: disease.nameId,
      diseaseScientific: disease.nameLatin,
      diseaseType: disease.type,
      confidence: topPrediction.score * 100,
      detectionTime: DateTime.now(),
      status: disease.id == 'healthy' ? 'healthy' : 'diseased',
    );

    // Save to local database
    await localDataSource.saveDetection(result);

    return result;
  }

  DiseaseModel _mapLabelToDisease(String label) {
    // Map API label to disease ID
    final labelLower = label.toLowerCase().replaceAll(' ', '_');
  
    final labelMap = {
      'blast': 'blast',
      'rice_blast': 'blast',
      'brown_spot': 'brown_spot',
      'brownspot': 'brown_spot',
      'tungro': 'tungro',
      'rice_tungro': 'tungro',
      'bacterial_leaf_blight': 'bacterial_blight',
      'bacterialleafblight': 'bacterial_blight',
      'healthy': 'healthy',
    };

    final diseaseId = labelMap[labelLower] ?? 'healthy';
    return diseaseDataSource.getDiseaseById(diseaseId) ?? 
          diseaseDataSource.getDiseaseById('healthy')!;
  }

  List<DetectionResultModel> getAllDetections() {
    return localDataSource.getAllDetections();
  }

  Future<List<DetectionResultModel>> getDetectionsByStatus(String status) async {
    return await localDataSource.getDetectionsByStatus(status);
  }

  Future<List<DetectionResultModel>> getDetectionsByDiseaseType(String diseaseType) async {
    return await localDataSource.getDetectionsByDiseaseType(diseaseType);
  }

  Future<DetectionResultModel?> getDetectionById(String id) async {
    return await localDataSource.getDetectionById(id);
  }

  Future<void> deleteDetection(String id) async {
    await localDataSource.deleteDetection(id);
  }

  Future<void> deleteMultipleDetections(List<String> ids) async {
    await localDataSource.deleteMultipleDetections(ids);
  }

  Future<Map<String, int>> getStatistics() async {
    return await localDataSource.getStatistics();
  }

  List<DiseaseModel> getAllDiseases() {
    return diseaseDataSource.getAllDiseases();
  }

  DiseaseModel? getDiseaseById(String id) {
    return diseaseDataSource.getDiseaseById(id);
  }
}
