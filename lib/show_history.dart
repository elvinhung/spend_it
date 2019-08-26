import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'dart:math';
import 'date_helper.dart';
import 'data.dart';


class ShowHistoryState extends State<ShowHistory> {

  @override
  Widget build(BuildContext context) {
    List<SliverStickyHeader> list = [];
    for (var year = DateTime.now().year; year >= 2015; year--) {
      Random random = new Random();
      int r = random.nextInt(255);
      int g = random.nextInt(255);
      int b = random.nextInt(255);
      Color color = new Color.fromARGB(255,r,g,b);
      List<Widget> listTiles = _buildListTiles(year);
      list.add(new SliverStickyHeader(
        header: new Container(
          decoration: new BoxDecoration(
            color: Colors.grey.shade900,
            border: new Border(
              bottom: new BorderSide(
                width: 1.5,
                color: color,
              )
            ),
          ),
          height: 50.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: new Text(
            year.toString(),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
        sliver: new SliverList(
          delegate: new SliverChildListDelegate(listTiles),
        ),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: CustomScrollView(
        slivers: list,
      ),
    );
  }

  List<Widget> _buildListTiles(int year) {
    List<Widget> listTiles = [];
    int monthsLength = DateHelper.months.length;
    if (year == DateTime.now().year) {
      monthsLength = DateTime.now().month;
    }
    for (var i = 0; i < monthsLength; i++) {
      listTiles.add(_buildRow(year, i));
      if (i + 1 != monthsLength) {
        listTiles.add(new Divider());
      }
    };
    return listTiles;
  }

  Widget _buildRow(int year, int month) {
    return ListTile(
      title: RichText(
        text: TextSpan(
          text: DateHelper.getMonthString(month),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Open Sans',
            fontSize: 16,
          ),
        ),
      ),
      onTap: () {

        Navigator.of(context).pop(new YearMonth(year, month + 1));
      },
    );
  }
}

class ShowHistory extends StatefulWidget {
  @override
  ShowHistoryState createState() => ShowHistoryState();
}