import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class PageDotsDemo extends StatefulWidget {
  const PageDotsDemo({super.key});

  @override
  State<PageDotsDemo> createState() => _PageDotsDemoState();
}

class _PageDotsDemoState extends State<PageDotsDemo> {
  final _pages = PageController();
  int _step = 0;

  static const _slides = [
    (RemixIcons.steering_2_fill, 'Every mile, logged', 'Drives record on their own the moment you start moving.'),
    (RemixIcons.money_dollar_circle_line, r'Worth $0.76 a mile', 'Business miles add up to a real deduction at tax time.'),
    (RemixIcons.receipt_line, 'Tolls and parking count', 'Snap a receipt and it attaches to the right trip.'),
    (RemixIcons.shield_check_line, 'Ready for your CPA', 'Export an IRS-ready mileage log in one tap.'),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Following a swipe',
          caption: 'The pill stretches between dots as the page moves.',
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(lq.radius.xl),
              child: Container(
                height: 320,
                color: c.surface,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _pages,
                        children: [
                          for (final (icon, title, body) in _slides)
                            // Scrolls only if large text outgrows the card.
                            SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(LqSpace.x6, LqSpace.x8, LqSpace.x6, LqSpace.x4),
                              child: Column(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(color: c.accentSoft, shape: BoxShape.circle),
                                    child: Icon(icon, size: LqIconSize.hero, color: c.accentOnSoft),
                                  ),
                                  const SizedBox(height: LqSpace.x4),
                                  Text(title, textAlign: TextAlign.center, style: lq.type.title3.copyWith(color: c.textPrimary)),
                                  const SizedBox(height: LqSpace.x2),
                                  Text(body, textAlign: TextAlign.center, style: lq.type.subhead.copyWith(color: c.textSecondary)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    LqPageDots(count: _slides.length, controller: _pages),
                    const SizedBox(height: LqSpace.x5),
                  ],
                ),
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Driven by an index',
          caption: 'Without a controller the pill springs to the new step.',
          children: [
            Row(
              children: [
                LqPageDots(count: 3, index: _step),
                const Spacer(),
                LqButton(
                  label: _step == 2 ? 'Start over' : 'Next step',
                  size: LqButtonSize.small,
                  variant: LqButtonVariant.secondary,
                  onPressed: () => setState(() => _step = (_step + 1) % 3),
                ),
              ],
            ),
            Text(
              const ['Add your vehicle', 'Allow location', 'Pick your platforms'][_step],
              style: lq.type.subhead.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
