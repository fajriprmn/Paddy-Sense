import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/detection_result_model.dart';

class DetectionCard extends StatelessWidget {
  final DetectionResultModel detection;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final ValueChanged<bool?>? onCheckboxChanged;

  const DetectionCard({
    super.key,
    required this.detection,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            children: [
              // Checkbox (if selectable)
              if (onCheckboxChanged != null)
                Checkbox(
                  value: isSelected,
                  onChanged: onCheckboxChanged,
                ),

              // Image Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                child: Image.file(
                  File(detection.imagePath),
                  width: AppDimensions.thumbnailSize,
                  height: AppDimensions.thumbnailSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: AppDimensions.thumbnailSize,
                      height: AppDimensions.thumbnailSize,
                      color: AppColors.backgroundGray,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),

              const SizedBox(width: AppDimensions.spaceM),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Disease Name
                    Text(
                      detection.diseaseName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppDimensions.spaceXS),

                    // Confidence
                    Text(
                      'Keyakinan ${detection.confidence.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(height: AppDimensions.spaceXS),

                    // Date
                    Text(
                      DateFormatter.formatRelative(detection.detectionTime),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textHint,
                          ),
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                  vertical: AppDimensions.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: detection.status == 'healthy'
                      ? AppColors.healthy.withOpacity(0.1)
                      : AppColors.diseased.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  detection.status == 'healthy' ? 'Sehat' : 'Sakit',
                  style: TextStyle(
                    color: detection.status == 'healthy'
                        ? AppColors.healthy
                        : AppColors.diseased,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
