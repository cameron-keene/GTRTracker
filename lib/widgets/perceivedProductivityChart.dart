import 'package:flutter/material.dart';
import 'package:gtrtracker/pages/data.dart';

// amplify packages we will need to use
import 'package:graphic/graphic.dart';

class perceivedProductivityChart extends StatefulWidget {
  const perceivedProductivityChart({super.key});

  @override
  State<perceivedProductivityChart> createState() =>
      _perceivedProductivityChartState();
}

class _perceivedProductivityChartState
    extends State<perceivedProductivityChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 350,
      height: 300,
      child: Chart(
        data: intervalData,
        variables: {
          'id': Variable(
            accessor: (Map map) => map['id'] as String,
          ),
          'min': Variable(
            accessor: (Map map) => map['min'] as num,
            scale: LinearScale(min: 0, max: 160),
          ),
          'max': Variable(
            accessor: (Map map) => map['max'] as num,
            scale: LinearScale(min: 0, max: 160),
          ),
        },
        elements: [
          IntervalElement(
            position: Varset('id') * (Varset('min') + Varset('max')),
            shape: ShapeAttr(
                value: RectShape(borderRadius: BorderRadius.circular(2))),
          )
        ],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
      ),
    );
  }
}
