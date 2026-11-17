import 'package:flutter/widgets.dart';

import 'list_group.dart';

/// Stacks [LqDisclosure]s on one inset grouped surface, like an FAQ. With
/// [exclusive], opening one closes whichever was open.
class LqDisclosureGroup extends StatefulWidget {
  const LqDisclosureGroup({
    super.key,
    required this.children,
    this.exclusive = false,
    this.header,
    this.footer,
  });

  /// The disclosures, top to bottom.
  final List<Widget> children;

  /// Whether only one disclosure may be open at a time.
  final bool exclusive;

  /// Sentence-case title above the surface.
  final String? header;

  /// Quiet note under the surface.
  final String? footer;

  /// The slot naming the open disclosure, or null if the group is not
  /// exclusive (or there is no group).
  static ValueNotifier<Object?>? exclusiveOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_DisclosureScope>()?.open;

  @override
  State<LqDisclosureGroup> createState() => _LqDisclosureGroupState();
}

class _LqDisclosureGroupState extends State<LqDisclosureGroup> {
  final _open = ValueNotifier<Object?>(null);

  @override
  void dispose() {
    _open.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = LqListGroup(
      header: widget.header,
      footer: widget.footer,
      leadingInset: false,
      children: widget.children,
    );
    return _DisclosureScope(
      open: widget.exclusive ? _open : null,
      child: group,
    );
  }
}

class _DisclosureScope extends InheritedWidget {
  const _DisclosureScope({required this.open, required super.child});

  final ValueNotifier<Object?>? open;

  @override
  bool updateShouldNotify(_DisclosureScope old) => old.open != open;
}
