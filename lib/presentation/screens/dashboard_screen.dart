import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/date_formatter.dart';
import '../providers/detection_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/detection_card.dart';
import '../widgets/empty_state.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(statisticsProvider);
    final historyAsync = ref.watch(detectionHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              AppStrings.appTagline,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(statisticsProvider);
          ref.invalidate(detectionHistoryProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Cards
              statisticsAsync.when(
                data: (stats) => Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: AppStrings.totalScan,
                        value: stats['totalScan'].toString(),
                        color: AppColors.primary,
                        icon: Icons.analytics_outlined,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: StatCard(
                        title: AppStrings.healthy,
                        value: stats['healthy'].toString(),
                        color: AppColors.healthy,
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: StatCard(
                        title: AppStrings.diseased,
                        value: stats['diseased'].toString(),
                        color: AppColors.diseased,
                        icon: Icons.warning_amber_outlined,
                      ),
                    ),
                  ],
                ),
                loading: () => const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Text('Error: $error'),
              ),

              const SizedBox(height: AppDimensions.spaceL),

              // Recent Detections Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.recentDetections,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to history screen
                      DefaultTabController.of(context).animateTo(2);
                    },
                    child: const Text(AppStrings.viewAll),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceM),

              // Recent Detections List
              historyAsync.when(
                data: (detections) {
                  if (detections.isEmpty) {
                    return const EmptyState(
                      icon: Icons.history,
                      title: AppStrings.emptyHistoryTitle,
                      message: AppStrings.emptyHistoryMessage,
                    );
                  }

                  final recentDetections = detections.take(5).toList();

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentDetections.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppDimensions.spaceM),
                    itemBuilder: (context, index) {
                      final detection = recentDetections[index];
                      return DetectionCard(
                        detection: detection,
                        onTap: () {
                          // Navigate to detail screen
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
              ),

              const SizedBox(height: AppDimensions.spaceXL),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to camera screen
          DefaultTabController.of(context).animateTo(1);
        },
        icon: const Icon(Icons.camera_alt),
        label: const Text(AppStrings.startDetection),
      ),
    );
  }
}
