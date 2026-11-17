import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class TabsDemo extends StatefulWidget {
  const TabsDemo({super.key});

  @override
  State<TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo> {
  int _vehicle = 0;
  int _kind = 0;
  int _category = 0;

  static const _vehicleTabs = ['Drives', 'Fuel', 'Service', 'Compliance'];
  static const _pages = [
    [('Midtown → JFK Terminal 4', '18.4 mi'), ('Astoria → Williamsburg', '7.9 mi'), ('Home → Costco Sunnyside', '4.2 mi')],
    [('Shell, Queens Blvd · 11.2 gal', r'$41.30'), ('BP, Northern Blvd · 9.8 gal', r'$36.05'), ('Costco Gas · 12.4 gal', r'$42.66')],
    [('Oil change · 48,210 mi', r'$64.99'), ('Front brake pads', r'$189.00'), ('Tire rotation', r'$25.00')],
    [('Registration renews', 'Mar 14'), ('Inspection due', 'Jan 2'), ('TLC insurance', 'Active')],
  ];
  static const _kinds = ['All', 'Business', 'Personal'];
  static const _counts = ['412 drives', '371 drives', '41 drives'];
  static const _categories = ['All', 'Delivery', 'Rideshare', 'Medical', 'Charity', 'Moving', 'Commute', 'Unclassified'];

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final quiet = lq.type.subhead.copyWith(color: lq.colors.textSecondary);
    return DemoColumn(
      children: [
        LqSection(
          title: 'Swipeable pages',
          caption: 'Swipe the cards: the pill follows your finger.',
          children: [
            SizedBox(
              height: 252,
              child: LqTabs(
                tabs: _vehicleTabs,
                index: _vehicle,
                onChanged: (i) => setState(() => _vehicle = i),
                pages: [for (final rows in _pages) _Page(rows: rows)],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Underline',
          children: [
            LqTabs(
              tabs: _kinds,
              index: _kind,
              style: LqTabsStyle.underline,
              onChanged: (i) => setState(() => _kind = i),
            ),
            Text('${_counts[_kind]} this tax year', style: quiet),
          ],
        ),
        LqSection(
          title: 'Many tabs',
          caption: 'Labels scroll sideways and keep the current one in view.',
          children: [
            LqTabs(
              tabs: _categories,
              index: _category,
              onChanged: (i) => setState(() => _category = i),
            ),
            Text('Filtering by ${_categories[_category]}', style: quiet),
          ],
        ),
      ],
    );
  }
}

/// One tab's page: a card of rows, as on the vehicle screen.
class _Page extends StatelessWidget {
  const _Page({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(lq.radius.lg),
          border: Border.all(color: c.border),
        ),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) Container(height: 1, color: c.separator),
              SizedBox(
                height: LqSize.row,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: LqSpace.x4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          rows[i].$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: lq.type.body.copyWith(color: c.textPrimary),
                        ),
                      ),
                      Text(
                        rows[i].$2,
                        style: LqTypography.numeric(lq.type.subhead.copyWith(color: c.textSecondary)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
