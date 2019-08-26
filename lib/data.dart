import 'package:flutter/material.dart';

class Data {
  static const categories = [
    'Rent',
    'Food',
    'Savings',
    'Subscriptions',
    'Travel',
    'Extraneous',
  ];

  static final colorMap = {
    'Rent': Colors.pinkAccent,
    'Food': Colors.tealAccent,
    'Savings': Colors.lightBlueAccent,
    'Subscriptions': Colors.deepPurpleAccent,
    'Travel': Colors.purpleAccent,
    'Extraneous': Colors.yellowAccent,
  };
}

class YearMonth {
  int year;
  int month;

  YearMonth(this.year, this.month);

}