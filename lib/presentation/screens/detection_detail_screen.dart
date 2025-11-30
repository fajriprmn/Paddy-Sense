import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/detection_result_model.dart';
import '../providers/detection_provider.dart';

class DetectionDetailScreen extends ConsumerWidget {
  final DetectionResultModel detection;

  const DetectionDetailScreen({
    super.key,
    required this.detection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disease = ref.watch(diseaseProvider(
      _mapDiseaseNameToId(detection.diseaseName),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Deteksi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview
            AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                File(detection.imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.backgroundGray,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: detection.status == 'healthy'
                          ? AppColors.healthy.withOpacity(0.1)
                          : AppColors.diseased.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          detection.status == 'healthy'
                              ? Icons.check_circle
                              : Icons.warning,
                          size: AppDimensions.iconS,
                          color: detection.status == 'healthy'
                              ? AppColors.healthy
                              : AppColors.diseased,
                        ),
                        const SizedBox(width: AppDimensions.spaceS),
                        Text(
                          detection.status == 'healthy'
                              ? AppStrings.healthy
                              : AppStrings.diseased,
                          style: TextStyle(
                            color: detection.status == 'healthy'
                                ? AppColors.healthy
                                : AppColors.diseased,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spaceL),

                  // Disease Name
                  Text(
                    detection.diseaseName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: AppDimensions.spaceS),

                  // Scientific Name
                  Text(
                    detection.diseaseScientific,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                        ),
                  ),

                  const SizedBox(height: AppDimensions.spaceL),

                  // Confidence
                  Row(
                    children: [
                      const Icon(
                        Icons.analytics_outlined,
                        size: AppDimensions.iconS,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppDimensions.spaceS),
                      Text(
                        '${AppStrings.confidence}: ${detection.confidence.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spaceM),

                  // Detection Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: AppDimensions.iconS,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppDimensions.spaceS),
                      Text(
                        DateFormatter.formatDateTime(detection.detectionTime),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spaceL),

                  const Divider(),

                  const SizedBox(height: AppDimensions.spaceL),

                  // Disease Information
                  if (disease != null) ...[
                    Text(
                      AppStrings.diseaseInfo,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: AppDimensions.spaceM),

                    _buildInfoSection(
                      context,
                      AppStrings.diseaseType,
                      disease.type,
                    ),

                    const SizedBox(height: AppDimensions.spaceM),

                    _buildInfoSection(
                      context,
                      AppStrings.symptoms,
                      disease.symptoms,
                    ),

                    const SizedBox(height: AppDimensions.spaceM),

                    _buildInfoSection(
                      context,
                      AppStrings.treatment,
                      disease.treatment,
                    ),

                    const SizedBox(height: AppDimensions.spaceM),

                    _buildInfoSection(
                      context,
                      AppStrings.prevention,
                      disease.prevention,
                    ),
                  ],

                  const SizedBox(height: AppDimensions.spaceXL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
              ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  String _mapDiseaseNameToId(String name) {
    final map = {
      'Blas': 'blast',
      'Hawar Daun Bakteri': 'bacterial_blight',
      'Tungro': 'tungro',
      'Bercak Coklat': 'brown_spot',
      'Sehat': 'healthy',
    };
    return map[name] ?? 'healthy';
  }
}
