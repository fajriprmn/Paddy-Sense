import 'dart:io';
import 'package:dio/dio.dart';
import '../models/prediction_response.dart';

class RemoteDataSource {
  final Dio _dio;
  final String apiUrl;

  RemoteDataSource({
    required this.apiUrl,
  }) : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 60), // Longer timeout for Space wake-up
            receiveTimeout: const Duration(seconds: 60),
          ),
        );

  Future<PredictionResponse> predictDisease(File imageFile) async {
    int retries = 3;
    
    for (int i = 0; i < retries; i++) {
      try {
        // Create multipart form data for Hugging Face Space
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            imageFile.path,
            filename: 'image.jpg',
          ),
        });
        
        print('🔄 Sending request to: $apiUrl');
        print('📸 Image path: ${imageFile.path}');

        final response = await _dio.post(
          apiUrl,
          data: formData,
        );

        // Tambahkan setelah response
        print('✅ Response status: ${response.statusCode}');
        print('📦 Response data: ${response.data}');

        if (response.statusCode == 200) {
          final data = response.data;
      
          // NEW FORMAT: Handle response with 'success', 'predicted_class', 'confidence'
          if (data is Map && data.containsKey('predicted_class')) {
            final prediction = {
              'label': data['predicted_class'],
              'score': data['confidence'],
            };
            return PredictionResponse.fromJson([prediction]);
          }
          
          // If response is already a list of predictions
          if (data is List) {
            return PredictionResponse.fromJson(data);
          }
          
          // If response is wrapped in an object with 'predictions' key
          if (data is Map && data.containsKey('predictions')) {
            return PredictionResponse.fromJson(data['predictions'] as List);
          }
          
          // If response has 'label' and 'score' directly
          if (data is Map && data.containsKey('label')) {
            return PredictionResponse.fromJson([data]);
          }
          
          throw Exception('Unexpected response format: $data');
        } else {
          throw Exception('Failed to predict: ${response.statusCode}');
        }
      } on DioException catch (e) {
        final isLastRetry = i == retries - 1;
        
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          if (isLastRetry) {
            throw Exception('Request timeout. The model might be starting up. Please try again in a moment.');
          }
          // Wait before retry (Space might be waking up)
          await Future.delayed(Duration(seconds: 5 * (i + 1)));
          continue;
        } else if (e.type == DioExceptionType.connectionError) {
          if (isLastRetry) {
            throw Exception('No internet connection. Please check your network.');
          }
          await Future.delayed(Duration(seconds: 3));
          continue;
        } else if (e.response?.statusCode == 503) {
          if (isLastRetry) {
            throw Exception('Model is currently unavailable. Please try again later.');
          }
          // Space is sleeping, wait longer
          await Future.delayed(Duration(seconds: 10 * (i + 1)));
          continue;
        } else {
          throw Exception('Failed to connect to server: ${e.message}');
        }
      } catch (e) {
        if (i == retries - 1) {
          throw Exception('Unexpected error: $e');
        }
        await Future.delayed(Duration(seconds: 3));
      }
    }
    
    throw Exception('Failed after $retries attempts');
  }

  Future<bool> checkModelAvailability() async {
    try {
      final response = await _dio.get(apiUrl.replaceAll('/predict', ''));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
