import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

/// Sample drives for the preview only.
class SampleDrive {
  const SampleDrive(this.route, this.detail, this.miles, this.deduction, this.business);

  final String route;
  final String detail;
  final double miles;
  final double? deduction;
  final bool business;
}

const sampleDrives = [
  SampleDrive('Mission District → Sunset', 'Today, 6:41 PM · DoorDash', 18.2, 13.83, true),
  SampleDrive('San Jose → Menlo Park', 'Yesterday · Client meeting', 45.0, 34.20, true),
  SampleDrive('Home → Bay Club Fitness', 'Yesterday · Personal', 12.0, null, false),
  SampleDrive('SFO Terminal 2 → Palo Alto', 'Mon, Oct 21 · Uber', 38.5, 29.26, true),
];

/// The screen's subject: this year's deduction, its change, and the two
/// figures behind it.
class DeductionHero extends StatelessWidget {
  const DeductionHero({super.key, required this.businessMiles, required this.rate});

  final double businessMiles;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return LqCard(
      padding: const EdgeInsets.all(LqSpace.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deductions this year', style: lq.type.subheadMedium.copyWith(color: c.textSecondary)),
          const SizedBox(height: LqSpace.x2),
          LqAmount(value: businessMiles * rate, prefix: r'$'),
          const SizedBox(height: LqSpace.x2),
          Row(
            children: [
              Icon(RemixIcons.arrow_right_up_line, size: 16, color: c.positive),
              const SizedBox(width: 2),
              Text(r'$212.80', style: lq.type.subheadMedium.copyWith(color: c.positive)),
              const SizedBox(width: LqSpace.x1),
              Text('this week', style: lq.type.subhead.copyWith(color: c.textSecondary)),
            ],
          ),
          const SizedBox(height: LqSpace.x5),
          Container(height: 0.5, color: c.separator),
          const SizedBox(height: LqSpace.x4),
          Row(
            children: [
              Expanded(child: _Figure(label: 'Business miles', value: businessMiles, unit: 'mi', decimals: 1)),
              Expanded(child: _Figure(label: 'Drives logged', value: 59, decimals: 0)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, this.unit, this.decimals = 0});

  final String label;
  final double value;
  final String? unit;
  final int decimals;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: lq.type.footnote.copyWith(color: lq.colors.textSecondary)),
        const SizedBox(height: 2),
        LqAmount(value: value, unit: unit, decimals: decimals, style: lq.type.title2),
      ],
    );
  }
}

/// Unclassified miles, framed as money to claim (never as an alarm), with
/// the two-tap resolution the product rules ask for.
class UnclassifiedCard extends StatelessWidget {
  const UnclassifiedCard({
    super.key,
    required this.miles,
    required this.rate,
    required this.onBusiness,
    required this.onPersonal,
  });

  final double miles;
  final double rate;
  final VoidCallback onBusiness;
  final VoidCallback onPersonal;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final worth = (miles * rate).toStringAsFixed(2);
    return LqCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LqBadge(label: 'To review', tone: LqTone.caution, dot: true),
          const SizedBox(height: LqSpace.x3),
          Text('${miles.toStringAsFixed(0)} unclassified miles',
              style: lq.type.headline.copyWith(color: c.textPrimary)),
          const SizedBox(height: 2),
          Text(
            'Worth up to \$$worth if they were for work. Your odometer moved between Friday and Monday.',
            style: lq.type.subhead.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: LqSpace.x4),
          Row(
            children: [
              Expanded(
                child: LqButton(label: 'Business', expand: true, onPressed: onBusiness),
              ),
              const SizedBox(width: LqSpace.x3),
              Expanded(
                child: LqButton(
                  label: 'Personal',
                  variant: LqButtonVariant.secondary,
                  expand: true,
                  onPressed: onPersonal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Miles plus the deduction they earned, right-aligned in a drive row.
class DriveValue extends StatelessWidget {
  const DriveValue({super.key, required this.miles, this.deduction});

  final double miles;
  final double? deduction;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('${miles.toStringAsFixed(1)} mi',
            style: LqTypography.numeric(lq.type.bodyMedium).copyWith(color: c.textPrimary)),
        Text(
          deduction == null ? 'Personal' : '+\$${deduction!.toStringAsFixed(2)}',
          style: LqTypography.numeric(lq.type.footnote)
              .copyWith(color: deduction == null ? c.textTertiary : c.positive),
        ),
      ],
    );
  }
}
