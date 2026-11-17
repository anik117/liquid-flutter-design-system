import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import 'shimmer.dart';

export 'shimmer.dart' show LqShimmer;

enum _Shape { line, circle, rect, row }

/// A placeholder block shown while content loads: a text line, a circle, a
/// rectangle, or a whole list row. Blocks are sunken grey; an enclosing
/// [LqShimmer] sweeps one band of light across all of them. Screen readers
/// hear "Loading" once per block group, not the blocks themselves.
class LqSkeleton extends StatelessWidget {
  /// A line of text. [width] null fills the available width.
  const LqSkeleton.line({super.key, this.width, this.height = 12})
    : _shape = _Shape.line,
      radius = null;

  /// A circle, e.g. an avatar or icon.
  const LqSkeleton.circle({super.key, double size = LqSize.iconTile})
    : _shape = _Shape.circle,
      width = size,
      height = size,
      radius = null;

  /// A rectangle, e.g. a map thumbnail or a chart.
  const LqSkeleton.rect({
    super.key,
    this.width,
    required this.height,
    this.radius,
  }) : _shape = _Shape.rect;

  /// A placeholder matching an [LqListRow] with a leading tile, title,
  /// subtitle and trailing value.
  const LqSkeleton.row({super.key})
    : _shape = _Shape.row,
      width = null,
      height = LqSize.row,
      radius = null;

  final _Shape _shape;

  /// Block width; null fills the parent.
  final double? width;

  /// Block height.
  final double height;

  /// Corner radius of a [LqSkeleton.rect]; defaults to the card-ish md.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final block = _shape == _Shape.row ? const _Row() : _block(context);
    final covered = LqShimmer.covers(context);
    return ExcludeSemantics(
      excluding: covered,
      child: Semantics(
        label: covered ? null : 'Loading',
        child: covered ? block : LqShimmer(child: block),
      ),
    );
  }

  Widget _block(BuildContext context) {
    final lq = context.lq;
    final r = switch (_shape) {
      _Shape.circle => LqRadius.full,
      _Shape.rect => radius ?? lq.radius.md,
      _ => height / 2,
    };
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: lq.colors.surfaceSunken,
        borderRadius: BorderRadius.circular(r),
      ),
    );
  }
}

/// The [LqListRow] geometry: 16pt side padding, 52pt minimum height, a 32pt
/// tile, a title over a shorter subtitle and a trailing value.
class _Row extends StatelessWidget {
  const _Row();

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return Container(
      color: lq.colors.surface,
      constraints: const BoxConstraints(minHeight: LqSize.row),
      padding: const EdgeInsets.symmetric(
        horizontal: LqSpace.x4,
        vertical: LqSpace.x2 + 2,
      ),
      child: Row(
        children: [
          LqSkeleton.rect(
            width: LqSize.iconTile,
            height: LqSize.iconTile,
            radius: lq.radius.sm,
          ),
          const SizedBox(width: LqSpace.x3),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.62,
                  child: LqSkeleton.line(height: 13),
                ),
                SizedBox(height: LqSpace.x2),
                FractionallySizedBox(
                  widthFactor: 0.4,
                  child: LqSkeleton.line(height: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: LqSpace.x3),
          const LqSkeleton.line(width: 52, height: 13),
        ],
      ),
    );
  }
}
