import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/typography.dart';
import '../feedback/badge.dart';
import 'timeline_parts.dart';

/// One step on a [LqTimeline], e.g. "Started · 6:12 PM · Mission District".
class LqTimelineEvent {
  const LqTimelineEvent({
    required this.title,
    this.time,
    this.body,
    this.icon,
    this.tone,
  });

  /// What happened, e.g. "Stop".
  final String title;

  /// When, shown on the right in tabular figures, e.g. "6:12 PM".
  final String? time;

  /// Detail under the title, e.g. "DoorDash pickup · Mission St".
  final String? body;

  /// Glyph on the rail; null draws a plain dot.
  final IconData? icon;

  /// Tint for the marker when it is not the current step.
  final LqTone? tone;
}

/// A vertical list of events joined by a rail, like a drive's stops. The
/// [current] step is highlighted with the accent and a soft pulse.
class LqTimeline extends StatelessWidget {
  const LqTimeline({super.key, required this.events, this.current});

  /// The events, oldest first.
  final List<LqTimelineEvent> events;

  /// Index of the live step, if any.
  final int? current;

  static const double _rail = 28;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < events.length; i++)
          _item(context, events[i], i, last: i == events.length - 1),
      ],
    );
  }

  Widget _item(BuildContext context, LqTimelineEvent e, int i, {required bool last}) {
    final lq = context.lq;
    final c = lq.colors;
    final isCurrent = i == current;
    final upcoming = current != null && i > current!;
    return MergeSemantics(
      child: Semantics(
        label: isCurrent ? 'Current' : null,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: _rail,
                child: Column(
                  children: [
                    TimelineMarker(
                      size: _rail,
                      icon: e.icon,
                      tone: e.tone,
                      current: isCurrent,
                    ),
                    if (!last)
                      Expanded(
                        child: Container(
                          width: 1.5,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: upcoming || isCurrent ? c.separator : c.borderStrong,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: LqSpace.x3),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: (_rail - 22) / 2,
                    bottom: last ? 0 : LqSpace.x5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              e.title,
                              style: lq.type.bodyMedium.copyWith(
                                color: isCurrent
                                    ? c.textAccent
                                    : (upcoming ? c.textSecondary : c.textPrimary),
                              ),
                            ),
                          ),
                          if (e.time != null) ...[
                            const SizedBox(width: LqSpace.x2),
                            Text(
                              e.time!,
                              style: LqTypography.numeric(lq.type.footnote)
                                  .copyWith(color: c.textSecondary, height: 22 / 13),
                            ),
                          ],
                        ],
                      ),
                      if (e.body != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          e.body!,
                          style: lq.type.subhead.copyWith(color: c.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
