import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class MonthlyData {
  final String category;
  final double amount;
  final charts.Color color;

  MonthlyData(this.category, this.amount, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha
  );
}