import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'data.dart';
import 'database_helper.dart';

class AddPaymentState extends State<AddPayment> {
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem> categoryList;
  DateTime _initialDate;
  DateTime _date;
  String _name;
  String _price;
  String _category;
  int _maxId;

  AddPaymentState(this._initialDate);

  @override
  void initState() {
    super.initState();
    categoryList = [];
    Data.categories.forEach((category) {
      categoryList.add(new DropdownMenuItem(
        child: Text(category),
        value: category,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Payment'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 270.0,
              child: TextFormField(
                decoration: new InputDecoration(
                  errorText: null,
                  labelText: 'Name',
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    gapPadding: 0,
                  ),
                  errorStyle: TextStyle(
                    height: 0,
                  ),
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(35),
                  WhitelistingTextInputFormatter(RegExp(r'[A-Za-z0-9 ]')),
                ],
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return '';
                  }
                  return null;
                },
                onSaved: (name) {
                  _name = name;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                    width: 100.0,
                    child: TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Price',
                        fillColor: Colors.white,
                        errorText: null,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          gapPadding: 0,
                        ),
                        errorStyle: TextStyle(
                          height: 0,
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp(r'^([0-9]{0,5}((.)[0-9]{0,2}))$')),
                      ],
                      validator: (price) {
                        if (price == null || price.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      onSaved: (price) {
                        _price = price;
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 170.0,
                    child: DateTimePickerFormField(
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      firstDate: DateTime(2000, 1, 1),
                      initialDate: _initialDate,
                      lastDate: DateTime.now(),
                      editable: false,
                      resetIcon: null,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          gapPadding: 0,
                        ),
                        errorStyle: TextStyle(
                          height: 0,
                        ),
                      ),
                      validator: (date) {
                        if (date == null) {
                          return '';
                        }
                        return null;
                      },
                      onSaved: (date) {
                        _date = date;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  width: 270.0,
                  height: 65,
                  child: DropdownButtonFormField(
                    value: _category,
                    items: categoryList,
                    validator: (selected) {
                      if (selected == null) {
                        return '';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        gapPadding: 0,
                      ),
                      errorStyle: TextStyle(
                        height: 0,
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0,5.0,0,5.0),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _getMaxId();
                    _saveToDatabase();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getMaxId() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    _maxId = await helper.getMaxId();
  }

  _saveToDatabase() async {
    Payment payment = new Payment();
    payment.id = _maxId;
    payment.name = _name;
    payment.price = double.parse(_price);
    payment.category = _category;
    payment.year = _date.year;
    payment.month = _date.month;
    payment.day = _date.day;
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(payment);
    print('inserted row: $id');
  }
}

class AddPayment extends StatefulWidget {

  DateTime initialDate;

  AddPayment(this.initialDate);

  @override
  AddPaymentState createState() => AddPaymentState(this.initialDate);
}