import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/startup_model.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/startup_provider.dart';
import '../widgets/startup_card.dart';
import 'startup_detail_screen.dart';
import 'submit_startup_screen.dart';

class StartupShowcaseScreen extends ConsumerStatefulWidget {
  const StartupShowcaseScreen({super.key});

  @override
  ConsumerState<StartupShowcaseScreen> createState() =>
      _StartupShowcaseScreenState();
}

class _StartupShowcaseScreenState
    extends ConsumerState<StartupShowcaseScreen> {
  StartupStage? _stageFilter;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(startupProvider);
    final filtered = _stageFilter == null
        ? all
        : all.where((s) => s.stage == _stageFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AppColors.textPrimary, size: 18),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('Startup Showcase',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SubmitStartupScreen()),
        ),
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.bgPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Submit My Startup',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterRow(),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No startups match this filter.',
                        style: TextStyle(color: AppColors.textSecondary)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => StartupCard(
                      startup: filtered[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StartupDetailScreen(
                              startupId: filtered[i].id),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterRow() {
    final filters = <(String, StartupStage?)>[
      ('All', null),
      ('Idea', StartupStage.idea),
      ('Prototype', StartupStage.prototype),
      ('Early Revenue', StartupStage.earlyRevenue),
    ];

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: filters
            .map((f) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    label: f.$1,
                    selected: _stageFilter == f.$2,
                    onTap: () => setState(() => _stageFilter = f.$2),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AppColors.gold : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.bgPrimary : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
