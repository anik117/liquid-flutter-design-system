import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoActivityIndicator;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show CircularProgressIndicator;

import '../../theme/lq_theme.dart';

/// An activity indicator that looks native on each platform: the iOS
/// petal spinner on iOS, a round-capped accent arc on Android. Use it for
/// short waits with no known length; prefer [LqSkeleton] for loading
/// content and [LqProgressBar] when progress is known.
class LqSpinner extends StatelessWidget {
  const LqSpinner({
    super.key,
    this.size = 20,
    this.color,
    this.semanticLabel = 'Loading',
  });

  /// Outer size of the indicator.
  final double size;

  /// Overrides the token color (secondary icon on iOS, accent on Android).
  final Color? color;

  /// Read by screen readers.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return Semantics(
      label: semanticLabel,
      child: SizedBox.square(
        dimension: size,
        child: lq.isIOS
            ? CupertinoActivityIndicator(
                radius: size / 2,
                color: color ?? c.iconSecondary,
              )
            : Padding(
                padding: EdgeInsets.all(size / 12),
                child: CircularProgressIndicator(
                  strokeWidth: (size / 9).clamp(2.0, 4.0),
                  strokeCap: StrokeCap.round,
                  color: color ?? c.accent,
                ),
              ),
      ),
    );
  }
}
