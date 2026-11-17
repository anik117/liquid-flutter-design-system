import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demos/charts/area_chart_demo.dart';
import '../demos/charts/bar_chart_demo.dart';
import '../demos/charts/chart_card_demo.dart';
import '../demos/charts/gauge_demo.dart';
import '../demos/charts/heatmap_demo.dart';
import '../demos/charts/horizontal_bar_demo.dart';
import '../demos/charts/legend_demo.dart';
import '../demos/charts/line_chart_demo.dart';
import '../demos/charts/multi_line_demo.dart';
import '../demos/charts/progress_list_demo.dart';
import '../demos/charts/ring_chart_demo.dart';
import '../demos/charts/sparkline_demo.dart';
import '../demos/charts/stacked_bar_demo.dart';
import 'catalog.dart';

final chartsEntries = <GalleryEntry>[
  GalleryEntry(
    name: 'Chart card',
    summary: 'Title, big number, delta, period switch and a chart',
    icon: RemixIcons.dashboard_3_line,
    builder: (_) => const ChartCardDemo(),
  ),
  GalleryEntry(
    name: 'Bar chart',
    summary: 'Bars that grow in, morph and pick with a finger',
    icon: RemixIcons.bar_chart_2_line,
    builder: (_) => const BarChartDemo(),
  ),
  GalleryEntry(
    name: 'Stacked bar chart',
    summary: 'Segments per bar by purpose, or grouped side by side',
    icon: RemixIcons.bar_chart_grouped_line,
    builder: (_) => const StackedBarDemo(),
  ),
  GalleryEntry(
    name: 'Horizontal bar chart',
    summary: 'Ranked rows with the leader in the accent',
    icon: RemixIcons.bar_chart_horizontal_line,
    builder: (_) => const HorizontalBarDemo(),
  ),
  GalleryEntry(
    name: 'Line chart',
    summary: 'This year against a dashed last year, with scrubbing',
    icon: RemixIcons.line_chart_line,
    builder: (_) => const LineChartDemo(),
  ),
  GalleryEntry(
    name: 'Area chart',
    summary: 'Soft gradient fills, single or stacked',
    icon: RemixIcons.stock_line,
    builder: (_) => const AreaChartDemo(),
  ),
  GalleryEntry(
    name: 'Multi-line chart',
    summary: 'Two to four series with a legend and a shared pill',
    icon: RemixIcons.pulse_line,
    builder: (_) => const MultiLineDemo(),
  ),
  GalleryEntry(
    name: 'Sparkline',
    summary: 'Tiny trend lines for rows and stat tiles',
    icon: RemixIcons.funds_line,
    builder: (_) => const SparklineDemo(),
  ),
  GalleryEntry(
    name: 'Ring chart',
    summary: 'A donut of shares with a center value and legend',
    icon: RemixIcons.donut_chart_line,
    builder: (_) => const RingChartDemo(),
  ),
  GalleryEntry(
    name: 'Gauge',
    summary: 'Progress toward a target on a springy arc',
    icon: RemixIcons.dashboard_2_line,
    builder: (_) => const GaugeDemo(),
  ),
  GalleryEntry(
    name: 'Heatmap',
    summary: 'Daily activity on a calendar grid',
    icon: RemixIcons.calendar_2_line,
    builder: (_) => const HeatmapDemo(),
  ),
  GalleryEntry(
    name: 'Budget bars',
    summary: 'Actual against target with a marker',
    icon: RemixIcons.scales_3_line,
    builder: (_) => const ProgressListDemo(),
  ),
  GalleryEntry(
    name: 'Legend and pill',
    summary: 'Series keys and the value pill charts share',
    icon: RemixIcons.list_check_3,
    builder: (_) => const LegendDemo(),
  ),
];
