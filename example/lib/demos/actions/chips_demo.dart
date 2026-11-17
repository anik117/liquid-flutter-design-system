import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class ChipsDemo extends StatefulWidget {
  const ChipsDemo({super.key});

  @override
  State<ChipsDemo> createState() => _ChipsDemoState();
}

class _ChipsDemoState extends State<ChipsDemo> {
  Set<String> _platforms = {'doordash', 'uber'};
  Set<String> _period = {'month'};
  bool _business = true;
  bool _review = false;
  final _tags = ['Airport run', 'Surge zone', 'Tolls paid', 'Long haul'];
  static const _suggested = ['Airport run', 'Surge zone', 'Tolls paid', 'Long haul', 'Parking'];

  static const _platformOptions = [
    LqChipOption(value: 'doordash', label: 'DoorDash'),
    LqChipOption(value: 'uber', label: 'Uber'),
    LqChipOption(value: 'instacart', label: 'Instacart'),
    LqChipOption(value: 'lyft', label: 'Lyft'),
    LqChipOption(value: 'flex', label: 'Amazon Flex'),
    LqChipOption(value: 'grubhub', label: 'Grubhub'),
  ];

  static const _periods = [
    LqChipOption(value: 'week', label: 'This week'),
    LqChipOption(value: 'month', label: 'This month'),
    LqChipOption(value: 'q3', label: 'Q3 2026'),
    LqChipOption(value: 'year', label: 'Tax year 2026', icon: RemixIcons.calendar_line),
  ];

  void _addTag() {
    final next = _suggested.where((t) => !_tags.contains(t));
    if (next.isNotEmpty) setState(() => _tags.add(next.first));
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final quiet = lq.type.subhead.copyWith(color: lq.colors.textSecondary);
    return DemoColumn(
      children: [
        LqSection(
          title: 'Filter by platform',
          caption: 'Multi select. Tap to toggle; a check slides in.',
          gap: LqSpace.x2,
          children: [
            LqChipGroup<String>(
              options: _platformOptions,
              selected: _platforms,
              multiSelect: true,
              onChanged: (v) => setState(() => _platforms = v),
            ),
            Text(
              _platforms.isEmpty
                  ? 'Showing drives from every platform'
                  : 'Showing drives from ${_platforms.length} of ${_platformOptions.length} platforms',
              style: quiet,
            ),
          ],
        ),
        LqSection(
          title: 'Report period',
          caption: 'Single select, wrapping. Exactly one stays picked.',
          children: [
            LqChipGroup<String>(
              options: _periods,
              selected: _period,
              wrap: true,
              onChanged: (v) => setState(() => _period = v),
            ),
          ],
        ),
        LqSection(
          title: 'Trip tags',
          caption: 'Input chips collapse away when removed.',
          trailing: LqButton(
            label: 'Add tag',
            size: LqButtonSize.small,
            variant: LqButtonVariant.plain,
            leadingIcon: RemixIcons.add_line,
            onPressed: _tags.length < _suggested.length ? _addTag : null,
          ),
          children: [
            Wrap(
              spacing: LqSpace.x2,
              children: [
                for (final t in _tags)
                  LqChip.input(
                    key: ValueKey(t),
                    label: t,
                    leadingIcon: RemixIcons.price_tag_3_line,
                    onRemoved: () => setState(() => _tags.remove(t)),
                  ),
              ],
            ),
            if (_tags.isEmpty) Text('No tags on this drive', style: quiet),
          ],
        ),
        LqSection(
          title: 'Single chips',
          caption: 'With leading icons, and disabled.',
          children: [
            Wrap(
              spacing: LqSpace.x2,
              children: [
                LqChip.filter(
                  label: 'Business',
                  leadingIcon: RemixIcons.briefcase_line,
                  selected: _business,
                  onSelected: (v) => setState(() => _business = v),
                ),
                LqChip.filter(
                  label: 'Needs review',
                  leadingIcon: RemixIcons.flag_line,
                  selected: _review,
                  onSelected: (v) => setState(() => _review = v),
                ),
                const LqChip.filter(
                  label: 'Synced (Pro)',
                  selected: false,
                  onSelected: null,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
