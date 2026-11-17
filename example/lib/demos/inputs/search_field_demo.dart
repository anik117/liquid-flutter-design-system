import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

const _drives = [
  ('Airport run, SFO', 'Nov 16 · 18.4 mi', r'$13.34'),
  ('DoorDash shift, Mission', 'Nov 15 · 42.1 mi', r'$30.52'),
  ('Client visit, Oakland', 'Nov 14 · 12.7 mi', r'$9.21'),
  ('Costco supply run', 'Nov 12 · 8.3 mi', r'$6.02'),
  ('Uber evening, Downtown', 'Nov 11 · 56.9 mi', r'$41.25'),
];

class SearchFieldDemo extends StatefulWidget {
  const SearchFieldDemo({super.key});

  @override
  State<SearchFieldDemo> createState() => _SearchFieldDemoState();
}

class _SearchFieldDemoState extends State<SearchFieldDemo> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final hits = _drives.where((d) => d.$1.toLowerCase().contains(q)).toList();
    return DemoColumn(
      children: [
        LqSection(
          title: 'Search drives',
          caption: 'Focus the field: Cancel springs in. Cancel clears and closes.',
          children: [
            LqSearchField(
              placeholder: 'Search drives',
              onChanged: (v) => setState(() => _query = v),
            ),
            if (hits.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: LqSpace.x6),
                child: Text(
                  'No drives match “$_query”.',
                  textAlign: TextAlign.center,
                  style: context.lq.type.subhead.copyWith(
                    color: context.lq.colors.textSecondary,
                  ),
                ),
              )
            else
              LqListGroup(
                leadingInset: false,
                children: [
                  for (final d in hits)
                    LqListRow(title: d.$1, subtitle: d.$2, value: d.$3),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
