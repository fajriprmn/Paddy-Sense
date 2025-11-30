import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/datasources/disease_data_source.dart';
import '../../data/repositories/detection_repository.dart';
import '../../data/models/detection_result_model.dart';
import '../../data/models/disease_model.dart';

// Data sources
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  // Hugging Face Space URL
  const apiUrl = 'https://woyazee-padi-mobilenetv3.hf.space/predict';
  
  return RemoteDataSource(
    apiUrl: apiUrl,
  );
});

final diseaseDataSourceProvider = Provider<DiseaseDataSource>((ref) {
  return DiseaseDataSource();
});

// Repository
final detectionRepositoryProvider = Provider<DetectionRepository>((ref) {
  return DetectionRepository(
    localDataSource: ref.read(localDataSourceProvider),
    remoteDataSource: ref.read(remoteDataSourceProvider),
    diseaseDataSource: ref.read(diseaseDataSourceProvider),
  );
});

// Detection state
class DetectionState {
  final bool isLoading;
  final DetectionResultModel? result;
  final String? error;

  DetectionState({
    this.isLoading = false,
    this.result,
    this.error,
  });

  DetectionState copyWith({
    bool? isLoading,
    DetectionResultModel? result,
    String? error,
  }) {
    return DetectionState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
    );
  }
}

// Detection notifier
class DetectionNotifier extends StateNotifier<DetectionState> {
  final DetectionRepository repository;

  DetectionNotifier(this.repository) : super(DetectionState());

  Future<void> detectDisease(File imageFile) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await repository.detectDisease(imageFile);
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() {
    state = DetectionState();
  }
}

final detectionProvider = StateNotifierProvider<DetectionNotifier, DetectionState>((ref) {
  return DetectionNotifier(ref.read(detectionRepositoryProvider));
});

// Detection history - loads once
final detectionHistoryProvider = FutureProvider<List<DetectionResultModel>>((ref) async {
  final repository = ref.read(detectionRepositoryProvider);
  return repository.getAllDetections();
});

// Filter state providers - no async, just state
final statusFilterProvider = StateProvider<String>((ref) => 'all');
final diseaseFilterProvider = StateProvider<String?>((ref) => null);

// Filtered detection history - filters in-memory, no async reload
final filteredDetectionHistoryProvider = Provider<AsyncValue<List<DetectionResultModel>>>((ref) {
  final historyAsync = ref.watch(detectionHistoryProvider);
  final statusFilter = ref.watch(statusFilterProvider);
  final diseaseFilter = ref.watch(diseaseFilterProvider);
  
  return historyAsync.whenData((detections) {
    var filtered = detections;
    
    // Apply status filter
    if (statusFilter != 'all') {
      filtered = filtered.where((d) => d.status == statusFilter).toList();
    }
    
    // Apply disease name filter (only when diseased is selected)
    if (statusFilter == 'diseased' && diseaseFilter != null && diseaseFilter.isNotEmpty) {
      filtered = filtered.where((d) => d.diseaseName == diseaseFilter).toList();
    }
    
    return filtered;
  });
});

// Statistics
final statisticsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.read(detectionRepositoryProvider);
  return await repository.getStatistics();
});

// Disease library
final diseaseLibraryProvider = Provider<List<DiseaseModel>>((ref) {
  final repository = ref.read(detectionRepositoryProvider);
  return repository.getAllDiseases();
});

// Single disease
final diseaseProvider = Provider.family<DiseaseModel?, String>((ref, id) {
  final repository = ref.read(detectionRepositoryProvider);
  return repository.getDiseaseById(id);
});
