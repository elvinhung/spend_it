import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'monthly_data.dart';
import 'date_helper.dart';
import 'add_payment.dart';
import 'edit_payment.dart';
import 'database_helper.dart';
import 'data.dart';
import 'Utilities.dart';
import 'show_history.dart';
import 'my_flutter_app_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: DisplayAmount(),
      theme: ThemeData.dark(),
    );
  }
}

class DisplayAmountState extends State<DisplayAmount> with SingleTickerProviderStateMixin {
  Color _color;
  String _category;
  String _amount;
  String _monthString;
  String _yearString;
  int _month;
  int  _year;
  bool _animate;

  final List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.pie_chart)),
    Tab(icon: Icon(Icons.list)),
  ];
  TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _animate = true;
    _month = DateTime.now().month;
    _year = DateTime.now().year;
    _monthString = DateHelper.months[_month - 1];
    _yearString = _year.toString();
    _category = 'Total';
    _color = Colors.grey;
  }

  void _selectionModelUpdated(charts.SelectionModel<dynamic> model) {
    final selectedDatum = model.selectedDatum;
    Color color;

    if (selectedDatum.isNotEmpty) {
      _animate = false;

      color = new Color.fromARGB(
          selectedDatum.first.datum.color.a,
          selectedDatum.first.datum.color.r,
          selectedDatum.first.datum.color.g,
          selectedDatum.first.datum.color.b
      );

      setState(() {
        _category = selectedDatum.first.datum.category;
        _amount = selectedDatum.first.datum.amount.toStringAsFixed(2);
        _color = color;
      });
    }


  }


  Widget _buildChart(List<Payment> payments) {
    if (_category == 'Total') {
      _amount = Utilities.getSum(payments).toStringAsFixed(2);
    }
    final data = toMonthlyData(payments);
    final _spendingList = [
      new charts.Series<MonthlyData, String>(
        id: 'Spending',
        domainFn: (MonthlyData data, _) => data.category,
        measureFn: (MonthlyData data, _) => data.amount,
        colorFn: (MonthlyData data, _) => data.color,
        data: data,
      )
    ];
    final chart = new charts.PieChart(
        _spendingList,
        animate: _animate,
        selectionModels: [
          new charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: _selectionModelUpdated)
        ],
        defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 60,
        ),
    );
    final amountDisplayed = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'Open Sans',
              fontSize: 30
            ),
            text: '\$$_amount',
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                fontSize: 14,
                color: _color,
            ),
            text: '$_category',
          ),
        ),
      ],
    );
    return Stack(
      children: <Widget>[
        chart,
        Container(
          alignment: Alignment.center,
          child: amountDisplayed,
        ),
        Container(
          padding: EdgeInsets.only(top: 500.0),
          alignment: Alignment.center,
          child: FlatButton(
            child: Text('Show Total'),
            onPressed: () {
              setState(() {
                _category = 'Total';
                _color = Colors.grey;
              });
            },
          ),
        ),
//        Container(
//          padding: EdgeInsets.only(top: 650.0),
//          alignment: Alignment.center,
//          child: FlatButton(
//            color: Colors.red,
//            child: Text('Delete all payments (debug)'),
//            onPressed: () {
//              _deleteAll();
//              setState(() {});
//            },
//          ),
//        ),
      ],
    );
  }

  Widget _buildList(List<Payment> payments) {
    if (payments.length == 0) {
      return Center(
        child: RichText(
          text: TextSpan(
            text: 'No payments',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 18,
            ),
          ),
        ),
      );
    }
    List<SliverStickyHeader> list = Data.categories.map((category) {
      List<Payment> paymentList = payments.where((payment) => payment.category == category).toList();
      if (paymentList.length == 0) {
        return new SliverStickyHeader();
      }
      else {
        List<Widget> listTiles = _buildListTiles(paymentList);
        return new SliverStickyHeader(
          header: new Container(
            decoration: new BoxDecoration(
              color: Colors.grey.shade900,
              border: new Border(
                bottom: new BorderSide(
                    width: 1.5,
                    color: Data.colorMap[category]
                )
              ),
            ),
            height: 50.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: new Text(
              category,
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
        );      }
    }).toList();
    return CustomScrollView(
      slivers: list,
    );

  }

  List<Widget> _buildListTiles(List<Payment> paymentList) {
    List<Widget> listTiles = [];
    for (var i = 0; i < paymentList.length; i++) {
      listTiles.add(_buildRow(paymentList[i]));
      if (i + 1 != paymentList.length) {
        listTiles.add(new Divider());
      }
    };
    return listTiles;
  }

  Widget _buildRow(Payment payment) {
    String displayPrice = '\$' + payment.price.toStringAsFixed(2);
    return ListTile(
      title: RichText(
        text: TextSpan(
          text: displayPrice,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Open Sans',
            fontSize: 18,
          ),
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_horiz),
        onPressed: () {
          _pushEditPayment(payment);
        }
      ),
      subtitle: Text(' ${payment.name}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_monthString $_yearString'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.library_add),
            onPressed: _pushAddPayment,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(MyFlutterApp.archive),
              title: Text('History'),
              onTap: () {
                _pushPaymentHistory();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            Divider(),
          ],
        ),
      ),
      body: FutureBuilder<List<Payment>>(
        future: _getPayments(_year, _month),
        builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
          if (snapshot.hasData) {
            return TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildChart(snapshot.data),
                _buildList(snapshot.data),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  Future<List<Payment>> _getPayments(int year, int month) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    return await helper.queryPaymentsByMonth(year, month);
  }

  void _deleteAll() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteAll();
  }

  void _pushPaymentHistory() async {
    final res = await Navigator.of(context).push(
      MaterialPageRoute<YearMonth>(
        builder: (BuildContext context) {
          return ShowHistory();
        },
      ),
    );
    if (res != null) {
      setState(() {
        _category = 'Total';
        _year = res.year;
        _month = res.month;
        _yearString = res.year.toString();
        _monthString = DateHelper.getMonthString(res.month - 1);
      });
    }
    Navigator.pop(context);
  }

  void _pushAddPayment() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          if (_year == DateTime.now().year && _month == DateTime.now().month) {
            return AddPayment(DateTime.now());
          }
          return AddPayment(new DateTime(_year, _month));
        },
      ),
    );
    setState(() {});
  }

  void _pushEditPayment(Payment payment) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return EditPayment(payment);
        },
      ),
    );
    setState(() {});
  }

  List<MonthlyData> toMonthlyData(List<Payment> payments) {
    return Data.categories.map((category) {
      List<Payment> paymentList = payments.where((payment) => payment.category == category).toList();
      double total = Utilities.getSum(paymentList);
      return new MonthlyData(category, total, Data.colorMap[category]);
    }).toList();
  }
}

class DisplayAmount extends StatefulWidget {
  @override
  DisplayAmountState createState() => DisplayAmountState();
}
