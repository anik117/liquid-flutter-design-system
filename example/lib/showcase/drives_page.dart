import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import 'drives_parts.dart';

/// A first pass at the redesigned Drives tab, with sample data. One subject
/// (this year's deduction), the one thing to act on (unclassified miles),
/// then the list that explains the number. Claiming the miles updates the
/// total live.
class DrivesPage extends StatefulWidget {
  const DrivesPage({super.key, required this.bottomInset});

  final double bottomInset;

  @override
  State<DrivesPage> createState() => _DrivesPageState();
}

class _DrivesPageState extends State<DrivesPage> {
  static const _rate = 0.76;
  static const _gapMiles = 84.0;

  double _miles = 7821.2;
  bool _reviewed = false;

  void _resolve({required bool business}) {
    setState(() {
      _reviewed = true;
      if (business) _miles += _gapMiles;
    });
    LqToast.show(
      context,
      business
          ? 'Claimed ${_gapMiles.toStringAsFixed(0)} mi · +\$${(_gapMiles * _rate).toStringAsFixed(2)}'
          : 'Marked as personal miles',
      icon: RemixIcons.check_line,
      tone: business ? LqTone.positive : LqTone.neutral,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LqPageScaffold(
      title: 'Drives',
      subtitle: 'Tax year 2026 · 76¢ per business mile',
      bottomInset: widget.bottomInset,
      actions: [
        LqIconButton(
          icon: RemixIcons.search_line,
          semanticLabel: 'Search drives',
          onPressed: () {},
        ),
        LqIconButton(
          icon: RemixIcons.settings_4_line,
          semanticLabel: 'Settings',
          onPressed: () {},
        ),
      ],
      children: [
        // The review card owns its top gap, so the space closes with it.
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DeductionHero(businessMiles: _miles, rate: _rate),
            AnimatedSize(
              duration: LqMotion.of(context, LqMotion.slow),
              curve: LqMotion.emphasized,
              alignment: Alignment.topCenter,
              child: _reviewed
                  ? const SizedBox(width: double.infinity)
                  : Padding(
                      padding: const EdgeInsets.only(top: LqSpace.x6),
                      child: UnclassifiedCard(
                        miles: _gapMiles,
                        rate: _rate,
                        onBusiness: () => _resolve(business: true),
                        onPersonal: () => _resolve(business: false),
                      ),
                    ),
            ),
          ],
        ),
        LqListGroup(
          header: 'Recent drives',
          trailingHeader: LqButton(
            label: 'See all',
            variant: LqButtonVariant.plain,
            size: LqButtonSize.small,
            onPressed: () {},
          ),
          children: [
            for (final d in sampleDrives)
              LqListRow(
                leading: LqIconTile(
                  icon: d.business ? RemixIcons.car_fill : RemixIcons.home_5_line,
                  tone: d.business ? LqTone.accent : null,
                ),
                title: d.route,
                subtitle: d.detail,
                trailing: DriveValue(miles: d.miles, deduction: d.deduction),
                onTap: () {},
              ),
          ],
        ),
      ],
    );
  }
}
