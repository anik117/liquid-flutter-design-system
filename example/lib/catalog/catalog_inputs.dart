import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demos/inputs/date_time_demo.dart';
import '../demos/inputs/otp_demo.dart';
import '../demos/inputs/radio_demo.dart';
import '../demos/inputs/search_field_demo.dart';
import '../demos/inputs/segmented_demo.dart';
import '../demos/inputs/select_demo.dart';
import '../demos/inputs/slider_demo.dart';
import '../demos/inputs/stepper_demo.dart';
import '../demos/inputs/text_area_demo.dart';
import '../demos/inputs/text_field_demo.dart';
import '../demos/inputs/toggles_demo.dart';
import 'catalog.dart';

final inputsEntries = <GalleryEntry>[
  GalleryEntry(
    name: 'Text field',
    summary: 'Labelled input on the native keyboard and edit menu',
    icon: RemixIcons.input_field,
    builder: (_) => const TextFieldDemo(),
  ),
  GalleryEntry(
    name: 'Switch and checkbox',
    summary: 'On/off and yes/no choices',
    icon: RemixIcons.toggle_line,
    builder: (_) => const TogglesDemo(),
  ),
  GalleryEntry(
    name: 'Segmented control',
    summary: 'Pick one of a few options; tap or drag',
    icon: RemixIcons.layout_column_line,
    builder: (_) => const SegmentedDemo(),
  ),
  GalleryEntry(
    name: 'Text area',
    summary: 'Multi-line notes that grow, with a character counter',
    icon: RemixIcons.file_text_line,
    builder: (_) => const TextAreaDemo(),
  ),
  GalleryEntry(
    name: 'Search field',
    summary: 'iOS search capsule with a springy Cancel',
    icon: RemixIcons.search_line,
    builder: (_) => const SearchFieldDemo(),
  ),
  GalleryEntry(
    name: 'Stepper',
    summary: 'Small counts: tap or hold to step',
    icon: RemixIcons.add_circle_line,
    builder: (_) => const StepperDemo(),
  ),
  GalleryEntry(
    name: 'Slider',
    summary: 'Drag a value; steps tick and snap on a spring',
    icon: RemixIcons.equalizer_line,
    builder: (_) => const SliderDemo(),
  ),
  GalleryEntry(
    name: 'Radio',
    summary: 'Pick exactly one of a few options',
    icon: RemixIcons.radio_button_line,
    builder: (_) => const RadioDemo(),
  ),
  GalleryEntry(
    name: 'Select',
    summary: 'Field that opens a wheel or list picker',
    icon: RemixIcons.dropdown_list,
    builder: (_) => const SelectDemo(),
  ),
  GalleryEntry(
    name: 'Date and time',
    summary: 'Fields that open the native date and time pickers',
    icon: RemixIcons.calendar_line,
    builder: (_) => const DateTimeDemo(),
  ),
  GalleryEntry(
    name: 'One-time code',
    summary: 'Digit boxes with autofill and paste',
    icon: RemixIcons.shield_keyhole_line,
    builder: (_) => const OtpDemo(),
  ),
];
