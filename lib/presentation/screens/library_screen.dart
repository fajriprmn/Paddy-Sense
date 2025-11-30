import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../providers/detection_provider.dart';
import '../widgets/disease_card.dart';
import 'disease_detail_screen.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diseases = ref.watch(diseaseLibraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.diseaseLibrary),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: diseases.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimensions.spaceM),
        itemBuilder: (context, index) {
          final disease = diseases[index];
          return DiseaseCard(
            disease: disease,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiseaseDetailScreen(disease: disease),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
