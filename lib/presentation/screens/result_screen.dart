import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/date_formatter.dart';
import '../providers/detection_provider.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detectionState = ref.watch(detectionProvider);

    if (detectionState.result == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.detectionResult),
        ),
        body: const Center(
          child: Text('No result available'),
        ),
      );
    }

    final result = detectionState.result!;
    final disease = ref.watch(diseaseProvider(
      _mapDiseaseNameToId(result.diseaseName),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.detectionResult),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(detectionProvider.notifier).reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview
            AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                File(result.imagePath),
                fit: BoxFit.cover,
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
                      color: result.status == 'healthy'
                          ? AppColors.healthy.withOpacity(0.1)
                          : AppColors.diseased.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          result.status == 'healthy'
                              ? Icons.check_circle
                              : Icons.warning,
                          size: AppDimensions.iconS,
                          color: result.status == 'healthy'
                              ? AppColors.healthy
                              : AppColors.diseased,
                        ),
                        const SizedBox(width: AppDimensions.spaceS),
                        Text(
                          result.status == 'healthy'
                              ? AppStrings.healthy
                              : AppStrings.diseased,
                          style: TextStyle(
                            color: result.status == 'healthy'
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
                    result.diseaseName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: AppDimensions.spaceS),

                  // Scientific Name
                  Text(
                    result.diseaseScientific,
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
                        '${AppStrings.confidence}: ${result.confidence.toStringAsFixed(1)}%',
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
                        DateFormatter.formatDateTime(result.detectionTime),
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

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(detectionProvider.notifier).reset();
                            Navigator.pop(context);
                          },
                          child: const Text(AppStrings.retake),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(detectionProvider.notifier).reset();
                            Navigator.pop(context);
                            DefaultTabController.of(context).animateTo(0);
                          },
                          child: const Text(AppStrings.ok),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spaceL),
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
