import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class _Vehicle {
  const _Vehicle(this.name, this.detail, this.miles, this.icon);

  final String name;
  final String detail;
  final double miles;
  final IconData icon;
}

class CarouselDemo extends StatefulWidget {
  const CarouselDemo({super.key});

  @override
  State<CarouselDemo> createState() => _CarouselDemoState();
}

class _CarouselDemoState extends State<CarouselDemo> {
  static const _vehicles = [
    _Vehicle('Toyota Prius', '2019 · Primary', 6412.3, RemixIcons.car_line),
    _Vehicle('Honda Odyssey', '2016 · Weekend shifts', 1204.8, RemixIcons.taxi_line),
    _Vehicle('Ford Transit', '2021 · Catering runs', 288.1, RemixIcons.truck_line),
  ];

  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Vehicles',
          caption: 'Swipe between cars. Neighbors peek in and shrink back.',
          children: [
            LqCarousel(
              height: 168,
              itemCount: _vehicles.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final v = _vehicles[i];
                return LqCard(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          LqIconTile(icon: v.icon, tone: LqTone.accent),
                          const SizedBox(width: LqSpace.x3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(v.name, style: lq.type.headline),
                                Text(
                                  v.detail,
                                  style: lq.type.subhead.copyWith(color: c.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Business miles this year',
                        style: lq.type.footnote.copyWith(color: c.textSecondary),
                      ),
                      LqAmount(
                        value: v.miles,
                        unit: 'mi',
                        decimals: 1,
                        style: lq.type.title2,
                      ),
                    ],
                  ),
                );
              },
            ),
            Text(
              'Showing ${_vehicles[_page].name}',
              textAlign: TextAlign.center,
              style: lq.type.footnote.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
