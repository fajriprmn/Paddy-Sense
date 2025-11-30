import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../providers/detection_provider.dart';
import '../widgets/detection_card.dart';
import '../widgets/empty_state.dart';
import 'detection_detail_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final Set<String> _selectedIds = {};
  bool _isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(filteredDetectionHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelectionMode 
            ? '${_selectedIds.length} dipilih' 
            : AppStrings.navHistory),
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedIds.clear();
                  });
                },
              )
            : null,
        actions: [
          if (_isSelectionMode && _selectedIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteSelected,
            )
          else if (!_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                setState(() {
                  _isSelectionMode = true;
                });
              },
              tooltip: 'Hapus Riwayat',
            ),
        ],
      ),
      body: Column(
        children: [
          // Status Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            child: Row(
              children: [
                _buildFilterChip(AppStrings.filterAll, 'all'),
                const SizedBox(width: AppDimensions.spaceS),
                _buildFilterChip(AppStrings.filterHealthy, 'healthy'),
                const SizedBox(width: AppDimensions.spaceS),
                _buildFilterChip(AppStrings.filterDiseased, 'diseased'),
              ],
            ),
          ),

          // Disease Sub-filters (shown when 'diseased' is selected)
          if (ref.watch(statusFilterProvider) == 'diseased')
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDiseaseChip('Semua', null),
                    const SizedBox(width: AppDimensions.spaceS),
                    _buildDiseaseChip('Bercak Coklat', 'Bercak Coklat'),
                    const SizedBox(width: AppDimensions.spaceS),
                    _buildDiseaseChip('Blas', 'Blas'),
                    const SizedBox(width: AppDimensions.spaceS),
                    _buildDiseaseChip('Tungro', 'Tungro'),
                    const SizedBox(width: AppDimensions.spaceS),
                    _buildDiseaseChip('Hawar Daun Bakteri', 'Hawar Daun Bakteri'),
                  ],
                ),
              ),
            ),

          const Divider(height: 1),

          // Detection List
          Expanded(
            child: historyAsync.when(
              data: (detections) {
                if (detections.isEmpty) {
                  return const EmptyState(
                    icon: Icons.history,
                    title: AppStrings.emptyHistoryTitle,
                    message: AppStrings.emptyHistoryMessage,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(detectionHistoryProvider);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    itemCount: detections.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppDimensions.spaceM),
                    itemBuilder: (context, index) {
                      final detection = detections[index];
                      final isSelected = _selectedIds.contains(detection.id);

                      return DetectionCard(
                        detection: detection,
                        isSelected: isSelected,
                        onTap: () {
                          if (_isSelectionMode) {
                            // Toggle selection in selection mode
                            setState(() {
                              if (isSelected) {
                                _selectedIds.remove(detection.id);
                              } else {
                                _selectedIds.add(detection.id);
                              }
                            });
                          } else {
                            // Navigate to detail screen in normal mode
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetectionDetailScreen(
                                  detection: detection,
                                ),
                              ),
                            );
                          }
                        },
                        onLongPress: () {
                          // Long press to enter selection mode
                          if (!_isSelectionMode) {
                            setState(() {
                              _isSelectionMode = true;
                              _selectedIds.add(detection.id);
                            });
                          }
                        },
                        onCheckboxChanged: _isSelectionMode
                            ? (value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedIds.add(detection.id);
                                  } else {
                                    _selectedIds.remove(detection.id);
                                  }
                                });
                              }
                            : null,
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final currentFilter = ref.watch(statusFilterProvider);
    final isSelected = currentFilter == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        ref.read(statusFilterProvider.notifier).state = value;
        ref.read(diseaseFilterProvider.notifier).state = null; // Reset disease filter
        setState(() {
          _selectedIds.clear();
        });
      },
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildDiseaseChip(String label, String? diseaseName) {
    final currentDisease = ref.watch(diseaseFilterProvider);
    final isSelected = currentDisease == diseaseName;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        ref.read(diseaseFilterProvider.notifier).state = selected ? diseaseName : null;
        setState(() {
          _selectedIds.clear();
        });
      },
      selectedColor: AppColors.info,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Future<void> _deleteSelected() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.delete),
        content: Text('Hapus ${_selectedIds.length} deteksi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repository = ref.read(detectionRepositoryProvider);
      await repository.deleteMultipleDetections(_selectedIds.toList());
      
      setState(() {
        _selectedIds.clear();
        _isSelectionMode = false;
      });
      
      ref.invalidate(detectionHistoryProvider);
      ref.invalidate(statisticsProvider);
    }
  }
}
