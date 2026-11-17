import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show showModalBottomSheet;

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';

/// Opens a bottom sheet: grabber, rounded top, the raised surface color,
/// drag-to-dismiss, and the keyboard pushing content up rather than over it.
/// Forms belong in sheets so the page underneath keeps its place.
Future<T?> showLqSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
  Widget? trailing,
}) {
  final lq = context.lq;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: const Color(0x00000000),
    barrierColor: lq.colors.scrim,
    elevation: 0,
    builder: (sheetContext) => LqScope(
      data: lq,
      child: _SheetBody(title: title, trailing: trailing, builder: builder),
    ),
  );
}

class _SheetBody extends StatelessWidget {
  const _SheetBody({required this.builder, this.title, this.trailing});

  final WidgetBuilder builder;
  final String? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final radius = Radius.circular(lq.radius.xxl);

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: Container(
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          borderRadius: BorderRadius.vertical(top: radius),
        ),
        padding: EdgeInsets.fromLTRB(
          LqSpace.gutter,
          LqSpace.x2,
          LqSpace.gutter,
          (keyboard > 0 ? 0 : safeBottom) + LqSpace.x4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: c.borderStrong,
                  borderRadius: BorderRadius.circular(LqRadius.full),
                ),
              ),
            ),
            if (title != null || trailing != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: LqSpace.x3,
                  bottom: LqSpace.x4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title ?? '',
                        style: lq.type.title3.copyWith(color: c.textPrimary),
                      ),
                    ),
                    ?trailing,
                  ],
                ),
              )
            else
              const SizedBox(height: LqSpace.x4),
            Flexible(child: SingleChildScrollView(child: builder(context))),
          ],
        ),
      ),
    );
  }
}
