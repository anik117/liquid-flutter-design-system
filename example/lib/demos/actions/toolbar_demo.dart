import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class ToolbarDemo extends StatefulWidget {
  const ToolbarDemo({super.key});

  @override
  State<ToolbarDemo> createState() => _ToolbarDemoState();
}

class _ToolbarDemoState extends State<ToolbarDemo> {
  String _last = 'Tap a toolbar action';

  VoidCallback _say(String what) => () => setState(() => _last = what);

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final quiet = lq.type.subhead.copyWith(color: lq.colors.textSecondary);
    return DemoColumn(
      children: [
        LqSection(
          title: 'Over a trip',
          caption: 'Floats on glass over content; icons swell while held.',
          children: [
            _Stage(
              toolbar: LqToolbar(
                actions: [
                  LqToolbarAction(icon: RemixIcons.share_line, semanticLabel: 'Share trip', onPressed: _say('Shared trip summary')),
                  LqToolbarAction(icon: RemixIcons.edit_line, semanticLabel: 'Edit trip', onPressed: _say('Opened trip editor')),
                  LqToolbarAction(icon: RemixIcons.receipt_line, semanticLabel: 'Attach receipt', onPressed: _say('Attach a toll or parking receipt')),
                  LqToolbarAction(
                    icon: RemixIcons.delete_bin_line,
                    semanticLabel: 'Delete trip',
                    destructive: true,
                    onPressed: _say('Asked to delete trip'),
                  ),
                ],
              ),
            ),
            Text(_last, style: quiet),
          ],
        ),
        LqSection(
          title: 'With a text action',
          caption: 'One text action at the end, for finishing a mode.',
          children: [
            Center(
              child: LqToolbar(
                actions: [
                  LqToolbarAction(icon: RemixIcons.briefcase_line, semanticLabel: 'Mark business', onPressed: _say('Marked 3 drives business')),
                  LqToolbarAction(icon: RemixIcons.price_tag_3_line, semanticLabel: 'Tag drives', onPressed: _say('Tagging 3 drives')),
                  const LqToolbarAction(icon: RemixIcons.delete_bin_line, semanticLabel: 'Delete drives', destructive: true, onPressed: null),
                ],
                textAction: 'Done',
                onTextAction: _say('Finished selecting'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A mock trip-detail screen with the toolbar floating at the bottom.
class _Stage extends StatelessWidget {
  const _Stage({required this.toolbar});

  final Widget toolbar;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    Widget line(String label, String value) => Padding(
      padding: const EdgeInsets.only(top: LqSpace.x2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: lq.type.subhead.copyWith(color: c.textSecondary))),
          Text(value, style: LqTypography.numeric(lq.type.subheadMedium.copyWith(color: c.textPrimary))),
        ],
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(lq.radius.xl),
      child: ColoredBox(
        color: c.surfaceSunken,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(LqSpace.x3, LqSpace.x3, LqSpace.x3, LqSpace.x10),
              padding: const EdgeInsets.all(LqSpace.x4),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(lq.radius.lg),
                boxShadow: LqShadows.card(c.shadow),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tue, Nov 11 · DoorDash', style: lq.type.footnote.copyWith(color: c.textSecondary)),
                  const SizedBox(height: LqSpace.x1),
                  Text('Midtown → JFK Terminal 4', style: lq.type.headline.copyWith(color: c.textPrimary)),
                  const SizedBox(height: LqSpace.x2),
                  line('Distance', '18.4 mi'),
                  line('Deduction at 76¢/mi', r'$13.98'),
                  line('Tolls', r'$6.94'),
                  const SizedBox(height: LqSpace.x3),
                  // Stands in for the route map the toolbar floats over.
                  Container(
                    height: 96,
                    decoration: BoxDecoration(
                      color: c.surfaceSunken,
                      borderRadius: BorderRadius.circular(lq.radius.md),
                    ),
                    child: Center(child: Icon(RemixIcons.route_line, size: LqIconSize.hero, color: c.iconTertiary)),
                  ),
                ],
              ),
            ),
            Positioned(left: 0, right: 0, bottom: LqSpace.x3, child: Center(child: toolbar)),
          ],
        ),
      ),
    );
  }
}
