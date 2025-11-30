import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/disease_model.dart';

class DiseaseCard extends StatelessWidget {
  final DiseaseModel disease;
  final VoidCallback? onTap;

  const DiseaseCard({
    super.key,
    required this.disease,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getTypeColor(disease.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  _getTypeIcon(disease.type),
                  color: _getTypeColor(disease.type),
                  size: AppDimensions.iconL,
                ),
              ),

              const SizedBox(width: AppDimensions.spaceM),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disease.nameId,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      disease.nameLatin,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingS,
                        vertical: AppDimensions.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(disease.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: Text(
                        disease.type,
                        style: TextStyle(
                          color: _getTypeColor(disease.type),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'jamur':
        return AppColors.warning;
      case 'bakteri':
        return AppColors.error;
      case 'virus':
        return AppColors.info;
      case 'normal':
        return AppColors.healthy;
      default:
        return AppColors.neutral;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'jamur':
        return Icons.coronavirus_outlined;
      case 'bakteri':
        return Icons.bug_report_outlined;
      case 'virus':
        return Icons.warning_amber_outlined;
      case 'normal':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }
}
