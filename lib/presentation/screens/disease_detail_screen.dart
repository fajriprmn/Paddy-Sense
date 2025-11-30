import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/disease_model.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final DiseaseModel disease;

  const DiseaseDetailScreen({
    super.key,
    required this.disease,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(disease.nameId),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disease.nameId,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    Text(
                      disease.nameLatin,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                        vertical: AppDimensions.paddingS,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(disease.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: Text(
                        disease.type,
                        style: TextStyle(
                          color: _getTypeColor(disease.type),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spaceL),

            // Description
            _buildSection(
              context,
              'Deskripsi',
              disease.description,
              Icons.info_outline,
            ),

            const SizedBox(height: AppDimensions.spaceL),

            // Symptoms
            _buildSection(
              context,
              AppStrings.symptoms,
              disease.symptoms,
              Icons.coronavirus_outlined,
            ),

            const SizedBox(height: AppDimensions.spaceL),

            // Treatment
            _buildSection(
              context,
              AppStrings.treatment,
              disease.treatment,
              Icons.medical_services_outlined,
            ),

            const SizedBox(height: AppDimensions.spaceL),

            // Prevention
            _buildSection(
              context,
              AppStrings.prevention,
              disease.prevention,
              Icons.shield_outlined,
            ),

            const SizedBox(height: AppDimensions.spaceXL),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: AppDimensions.iconM,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimensions.spaceS),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
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
}
