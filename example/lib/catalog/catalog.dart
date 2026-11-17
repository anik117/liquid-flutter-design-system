import 'package:flutter/widgets.dart';

import 'catalog_actions.dart';
import 'catalog_charts.dart';
import 'catalog_data.dart';
import 'catalog_feedback.dart';
import 'catalog_foundations.dart';
import 'catalog_inputs.dart';
import 'catalog_motion.dart';
import 'catalog_navigation.dart';
import 'catalog_overlays.dart';

/// One component in the gallery.
class GalleryEntry {
  const GalleryEntry({
    required this.name,
    required this.summary,
    required this.icon,
    required this.builder,
  });

  /// Shown as the row title and the demo page's title.
  final String name;

  /// One line saying what it is for.
  final String summary;
  final IconData icon;

  /// Builds the demo: every variant and state of the component.
  final WidgetBuilder builder;
}

class GalleryCategory {
  const GalleryCategory(this.name, this.entries);

  final String name;
  final List<GalleryEntry> entries;
}

/// Every category, in the order the Components tab lists them. Each
/// category's entries live in their own `catalog_<category>.dart` file.
final galleryCategories = <GalleryCategory>[
  GalleryCategory('Foundations', foundationsEntries),
  GalleryCategory('Actions', actionsEntries),
  GalleryCategory('Inputs', inputsEntries),
  GalleryCategory('Navigation', navigationEntries),
  GalleryCategory('Feedback', feedbackEntries),
  GalleryCategory('Overlays', overlaysEntries),
  GalleryCategory('Data display', dataEntries),
  GalleryCategory('Charts', chartsEntries),
  GalleryCategory('Motion', motionEntries),
].where((c) => c.entries.isNotEmpty).toList();
