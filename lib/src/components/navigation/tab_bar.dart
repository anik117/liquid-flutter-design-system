import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'tab_bar_item.dart';

export 'tab_bar_item.dart' show LqTabItem;

/// A floating Liquid Glass tab bar. The selected tab sits on a soft bubble
/// that slides on a spring. Press and drag across the bar to scrub between
/// tabs, as on iOS 26: the bubble lifts while held and follows the finger.
/// An optional primary [action] (Start drive) floats beside it.
class LqTabBar extends StatefulWidget {
  const LqTabBar({
    super.key,
    required this.items,
    required this.index,
    required this.onChanged,
    this.action,
  });

  final List<LqTabItem> items;
  final int index;
  final ValueChanged<int> onChanged;
  final Widget? action;

  @override
  State<LqTabBar> createState() => _LqTabBarState();
}

class _LqTabBarState extends State<LqTabBar> {
  bool _held = false;
  double _tabWidth = 1;

  void _select(int i) {
    if (i == widget.index) return;
    HapticFeedback.selectionClick();
    widget.onChanged(i);
  }

  void _selectAt(double dx) =>
      _select((dx / _tabWidth).floor().clamp(0, widget.items.length - 1));

  void _hold(bool held) {
    if (held != _held) setState(() => _held = held);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final still = LqMotion.reduced(context);
    const pad = 4.0;

    final track = LayoutBuilder(
      builder: (context, box) {
        _tabWidth = box.maxWidth / widget.items.length;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _hold(true),
          onTapUp: (d) {
            _hold(false);
            _selectAt(d.localPosition.dx);
          },
          onTapCancel: () => _hold(false),
          onHorizontalDragStart: (d) {
            _hold(true);
            _selectAt(d.localPosition.dx);
          },
          onHorizontalDragUpdate: (d) => _selectAt(d.localPosition.dx),
          onHorizontalDragEnd: (_) => _hold(false),
          onHorizontalDragCancel: () => _hold(false),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: LqMotion.of(context, LqMotion.slow),
                curve: LqMotion.springCurve,
                left: _tabWidth * widget.index,
                width: _tabWidth,
                top: 0,
                bottom: 0,
                child: AnimatedScale(
                  scale: _held && !still ? 1.08 : 1,
                  duration: LqMotion.of(context, LqMotion.standard),
                  curve: LqMotion.springCurve,
                  // A soft grey bubble, as on iOS 26: it reads on pale glass
                  // where a white pill would disappear. Brighter while held.
                  child: AnimatedContainer(
                    duration: LqMotion.fast,
                    decoration: BoxDecoration(
                      color: _held ? c.glassBubbleHeld : c.glassBubble,
                      borderRadius: BorderRadius.circular(LqRadius.full),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < widget.items.length; i++)
                    Expanded(
                      child: LqTabCell(
                        item: widget.items[i],
                        selected: i == widget.index,
                        onSelect: () => _select(i),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        LqSpace.x4,
        0,
        LqSpace.x4,
        bottom > 0 ? bottom - LqSpace.x1 : LqSpace.x3,
      ),
      child: Row(
        children: [
          Expanded(
            child: LqGlass(
              weight: LqGlassWeight.thick,
              lit: _held,
              padding: const EdgeInsets.all(pad),
              child: SizedBox(height: LqSize.tabBar - pad * 2, child: track),
            ),
          ),
          if (widget.action != null) ...[
            const SizedBox(width: LqSpace.x3),
            widget.action!,
          ],
        ],
      ),
    );
  }
}
