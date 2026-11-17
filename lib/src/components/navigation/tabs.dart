import 'package:flutter/widgets.dart';

import '../../foundation/haptics.dart';
import '../../foundation/spring.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'tabs_parts.dart';

/// How [LqTabs] marks the current tab.
enum LqTabsStyle {
  /// A soft brand-tinted capsule behind the label.
  pill,

  /// A short brand bar under the label, over a hairline.
  underline,
}

/// In-page text tabs ("Drives / Fuel / Service") with a sliding pill or
/// underline. Give it [pages] and it adds a swipeable body below: the
/// indicator tracks the swipe continuously and labels shift color as it
/// passes. With many tabs the labels scroll sideways. Each change of tab
/// ticks a selection haptic.
class LqTabs extends StatefulWidget {
  const LqTabs({
    super.key,
    required this.tabs,
    required this.index,
    required this.onChanged,
    this.pages,
    this.controller,
    this.style = LqTabsStyle.pill,
    this.scrollable,
  });

  /// Tab labels, short.
  final List<String> tabs;

  /// The selected tab.
  final int index;

  /// Called with the new tab when tapped or swiped to.
  final ValueChanged<int> onChanged;

  /// One page per tab, swipeable. LqTabs then needs a bounded height.
  final List<Widget>? pages;

  /// Page controller to follow, e.g. for a PageView you place yourself.
  /// Created for you when [pages] is set and this is null.
  final PageController? controller;

  /// Pill or underline indicator.
  final LqTabsStyle style;

  /// Scroll the labels sideways. Defaults to true for more than four tabs.
  final bool? scrollable;

  @override
  State<LqTabs> createState() => _LqTabsState();
}

class _LqTabsState extends State<LqTabs> with SingleTickerProviderStateMixin {
  late final _anim = AnimationController.unbounded(
    vsync: this,
    value: widget.index.toDouble(),
  );
  PageController? _ownPages;

  /// The page a tap is animating to; swipe callbacks are ignored meanwhile.
  int? _target;

  PageController? get _pages => widget.controller ?? _ownPages;

  @override
  void initState() {
    super.initState();
    if (widget.pages != null && widget.controller == null) {
      _ownPages = PageController(initialPage: widget.index);
    }
  }

  @override
  void didUpdateWidget(LqTabs old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) _moveTo(widget.index);
  }

  @override
  void dispose() {
    _anim.dispose();
    _ownPages?.dispose();
    super.dispose();
  }

  bool get _attached {
    final pc = _pages;
    return pc != null && pc.hasClients && pc.position.haveDimensions;
  }

  double _position() =>
      _attached ? (_pages!.page ?? widget.index.toDouble()) : _anim.value;

  Future<void> _moveTo(int i) async {
    LqSpring.animate(_anim, i.toDouble(), context: context);
    if (!_attached || _pages!.page!.round() == i) return;
    final d = LqMotion.of(context, LqMotion.slow);
    if (d == Duration.zero) {
      _pages!.jumpToPage(i);
      return;
    }
    _target = i;
    await _pages!.animateToPage(i, duration: d, curve: LqMotion.emphasized);
    if (_target == i) _target = null;
  }

  void _tap(int i) {
    if (i == widget.index) return;
    LqHaptics.play(LqHaptic.selection);
    widget.onChanged(i);
  }

  void _onPage(int i) {
    if (_target != null || i == widget.index) return;
    LqHaptics.play(LqHaptic.selection);
    widget.onChanged(i);
  }

  @override
  Widget build(BuildContext context) {
    final strip = LqTabStrip(
      tabs: widget.tabs,
      animation: Listenable.merge([_anim, ?_pages]),
      position: _position,
      selected: widget.index,
      onTap: _tap,
      style: widget.style,
      scrollable: widget.scrollable ?? widget.tabs.length > 4,
    );
    if (widget.pages == null) return strip;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        strip,
        const SizedBox(height: LqSpace.x3),
        Expanded(
          child: PageView(
            controller: _pages,
            onPageChanged: _onPage,
            children: widget.pages!,
          ),
        ),
      ],
    );
  }
}
