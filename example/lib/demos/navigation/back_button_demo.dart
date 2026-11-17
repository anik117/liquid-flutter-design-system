import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class BackButtonDemo extends StatefulWidget {
  const BackButtonDemo({super.key});

  @override
  State<BackButtonDemo> createState() => _BackButtonDemoState();
}

class _BackButtonDemoState extends State<BackButtonDemo> {
  String _last = 'Tap a back button';

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return DemoColumn(
      children: [
        LqSection(
          title: 'In a navigator',
          caption: 'Open a drive, then go back: it pops the nearest navigator.',
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(lq.radius.xl),
              child: SizedBox(
                height: 280,
                child: Navigator(
                  onGenerateRoute: (_) => _route(const _DrivesPage()),
                ),
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Variants',
          caption: 'Round chevron, or a capsule naming the page you return to.',
          children: [
            Row(
              children: [
                LqBackButton(onPressed: () => setState(() => _last = 'Back (round)')),
                const SizedBox(width: LqSpace.x3),
                LqBackButton(
                  title: 'Drives',
                  onPressed: () => setState(() => _last = 'Back to Drives'),
                ),
                const SizedBox(width: LqSpace.x3),
                Flexible(
                  child: LqBackButton(
                    title: 'Quarterly estimated taxes',
                    onPressed: () => setState(() => _last = 'Back to a long title'),
                  ),
                ),
              ],
            ),
            Text(_last, style: lq.type.subhead.copyWith(color: c.textSecondary)),
          ],
        ),
      ],
    );
  }
}

Route<void> _route(Widget page) => PageRouteBuilder<void>(
  pageBuilder: (_, _, _) => page,
  transitionsBuilder: (context, animation, _, child) => SlideTransition(
    position: Tween(begin: const Offset(1, 0), end: Offset.zero)
        .chain(CurveTween(curve: LqMotion.emphasized))
        .animate(animation),
    child: child,
  ),
);

class _DrivesPage extends StatelessWidget {
  const _DrivesPage();

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return ColoredBox(
      color: lq.colors.surface,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: LqSpace.x2),
        children: [
          for (final (route, miles) in const [
            ('Midtown → JFK Terminal 4', '18.4 mi'),
            ('Astoria → Williamsburg', '7.9 mi'),
            ('Home → Costco Sunnyside', '4.2 mi'),
            ('LaGuardia → Upper West Side', '9.6 mi'),
          ])
            LqListRow(
              leading: const LqIconTile(icon: RemixIcons.car_line),
              title: route,
              value: miles,
              onTap: () => Navigator.of(context).push(_route(_DrivePage(route: route, miles: miles))),
            ),
        ],
      ),
    );
  }
}

class _DrivePage extends StatelessWidget {
  const _DrivePage({required this.route, required this.miles});

  final String route;
  final String miles;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return ColoredBox(
      color: c.canvas,
      child: Padding(
        padding: const EdgeInsets.all(LqSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LqBackButton(title: 'Drives'),
            const SizedBox(height: LqSpace.x5),
            Text(route, style: lq.type.title3.copyWith(color: c.textPrimary)),
            const SizedBox(height: LqSpace.x1),
            Text('$miles · DoorDash · Business', style: lq.type.subhead.copyWith(color: c.textSecondary)),
          ],
        ),
      ),
    );
  }
}
