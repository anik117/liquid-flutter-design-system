import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'scroll_edge.dart';

/// A page with an iOS-style large title. Glass action buttons float at the
/// top. Once the large title scrolls away, content dissolves into a
/// progressive blur at the top edge and a compact title fades in. Pulling
/// down at the top stretches the large title, as on iOS.
class LqPageScaffold extends StatefulWidget {
  const LqPageScaffold({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.bottomInset = 0,
  });

  final String title;

  /// One quiet line under the large title, e.g. "Tax year 2026".
  final String? subtitle;
  final List<Widget> children;

  /// Usually a back button (a glass [LqIconButton]).
  final Widget? leading;
  final List<Widget> actions;

  /// Space reserved at the bottom, e.g. for a floating tab bar.
  final double bottomInset;

  @override
  State<LqPageScaffold> createState() => _LqPageScaffoldState();
}

class _LqPageScaffoldState extends State<LqPageScaffold> {
  /// Scroll distance over which the large title hands over to the compact one.
  static const _collapseAt = 36.0;

  final _scroll = ScrollController();
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final collapsed = _scroll.offset > _collapseAt;
      if (collapsed != _collapsed) setState(() => _collapsed = collapsed);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final top = MediaQuery.paddingOf(context).top;
    const barHeight = 52.0;

    final title = AnimatedBuilder(
      animation: _scroll,
      builder: (context, child) {
        final offset = _scroll.hasClients ? _scroll.offset : 0.0;
        final stretch = LqMotion.reduced(context) || offset >= 0
            ? 1.0
            : 1 + (-offset / 600).clamp(0.0, 0.12);
        // The large title fades as it scrolls under the edge, handing over
        // to the compact title so the two never show at once.
        // A little longer than the hand-over, so the subtitle fades too.
        final fade = 1 - (offset / (_collapseAt * 1.5)).clamp(0.0, 1.0);
        return Opacity(
          opacity: fade,
          child: Transform.scale(
            scale: stretch,
            alignment: Alignment.bottomLeft,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: lq.type.largeTitle.copyWith(color: c.textPrimary),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: LqSpace.x1),
            Text(
              widget.subtitle!,
              style: lq.type.subhead.copyWith(color: c.textSecondary),
            ),
          ],
        ],
      ),
    );

    final content = ListView(
      controller: _scroll,
      padding: EdgeInsets.fromLTRB(
        LqSpace.gutter,
        top + barHeight,
        LqSpace.gutter,
        widget.bottomInset + LqSpace.x8,
      ),
      children: [
        title,
        const SizedBox(height: LqSpace.x5),
        for (var i = 0; i < widget.children.length; i++) ...[
          if (i > 0) const SizedBox(height: LqSpace.x6),
          widget.children[i],
        ],
      ],
    );

    final bar = SizedBox(
      height: top + barHeight + LqSpace.x4,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _collapsed ? 1 : 0,
              duration: LqMotion.of(context, LqMotion.standard),
              child: const LqScrollEdge(),
            ),
          ),
          Positioned(
            left: LqSpace.gutter,
            right: LqSpace.gutter,
            top: top + 4,
            height: LqSize.control,
            child: Row(
              children: [
                ?widget.leading,
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _collapsed ? 1 : 0,
                    duration: LqMotion.of(context, LqMotion.standard),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: lq.type.headline.copyWith(color: c.textPrimary),
                    ),
                  ),
                ),
                for (var i = 0; i < widget.actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: LqSpace.x2),
                  widget.actions[i],
                ],
                if (widget.actions.isEmpty && widget.leading != null)
                  const SizedBox(width: LqSize.control),
              ],
            ),
          ),
        ],
      ),
    );

    return ColoredBox(
      color: c.canvas,
      child: Stack(
        children: [
          content,
          Positioned(top: 0, left: 0, right: 0, child: bar),
        ],
      ),
    );
  }
}
