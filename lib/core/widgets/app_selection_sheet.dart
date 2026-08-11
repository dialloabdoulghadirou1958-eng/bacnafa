import 'package:flutter/material.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';

class SelectionItem<T> {
  final String id;
  final String label;
  final String? group;
  final T? data;

  const SelectionItem({
    required this.id,
    required this.label,
    this.group,
    this.data,
  });
}

Future<SelectionItem<T>?> showAppSelectionSheet<T>({
  required BuildContext context,
  required String title,
  required List<SelectionItem<T>> items,
  String searchHint = 'Rechercher…',
  SelectionItem<T>? initialSelection,
}) {
  return showModalBottomSheet<SelectionItem<T>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.dialog)),
    ),
    builder: (context) => _SelectionSheet<T>(
      title: title,
      items: items,
      searchHint: searchHint,
      initialSelection: initialSelection,
    ),
  );
}

class _SelectionSheet<T> extends StatefulWidget {
  final String title;
  final List<SelectionItem<T>> items;
  final String searchHint;
  final SelectionItem<T>? initialSelection;

  const _SelectionSheet({
    required this.title,
    required this.items,
    required this.searchHint,
    this.initialSelection,
  });

  @override
  State<_SelectionSheet<T>> createState() => _SelectionSheetState<T>();
}

class _SelectionSheetState<T> extends State<_SelectionSheet<T>> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final _scrollController = ScrollController();
  late SelectionItem<T>? _selected;

  String _query = '';
  bool _searchHasFocus = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection;
    _searchController.addListener(() {
      final next = _searchController.text;
      if (next != _query) {
        setState(() => _query = next);
      }
    });
    _searchFocus.addListener(() {
      setState(() => _searchHasFocus = _searchFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<SelectionItem<T>> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget
        .items
        .where((e) => e.label.toLowerCase().contains(q))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final maxHeight = mq.size.height * 0.85;
    final accent = const Color(0xFF5A54E8);

    final filtered = _filtered;
    final hasResults = filtered.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 22),
                    color: AppColors.textTertiary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                    color: _searchHasFocus ? accent : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 15,
                      color: AppColors.textTertiary,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        Icons.search_rounded,
                        color: _searchHasFocus ? accent : AppColors.textTertiary,
                        size: 20,
                      ),
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _searchFocus.requestFocus();
                            },
                            icon: const Icon(Icons.close_rounded, size: 18),
                            color: AppColors.textTertiary,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            visualDensity: VisualDensity.compact,
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            !hasResults
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                    child: Column(
                      children: [
                        Icon(
                          Icons.location_searching_rounded,
                          size: 36,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Aucune ville trouvée',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Essaie un autre mot-clé.',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  )
                : Flexible(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final isSelected = _selected?.id == item.id;
                          final showHeader = item.group != null &&
                              (index == 0 ||
                                  filtered[index - 1].group != item.group);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (item.group != null) ...[
                                if (showHeader)
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      AppSpacing.lg,
                                      index == 0 ? AppSpacing.sm : AppSpacing.md,
                                      AppSpacing.lg,
                                      AppSpacing.xs,
                                    ),
                                    child: Text(
                                      _query.trim().isEmpty ? item.group! : 'Résultats',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.textTertiary,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                              InkWell(
                                onTap: () => Navigator.of(context).pop(item),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF5A54E8).withValues(alpha: 0.08)
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.medium),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF5A54E8)
                                              : AppColors.surfaceContainer,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          size: 18,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.textTertiary,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Text(
                                          item.label,
                                          style: AppTextStyles.titleMedium.copyWith(
                                            color: AppColors.textPrimary,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Color(0xFF5A54E8),
                                          size: 22,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
