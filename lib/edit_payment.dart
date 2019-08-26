import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'data.dart';
import 'database_helper.dart';


class EditPaymentState extends State<EditPayment> {
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem> categoryList;
  DateTime _date;
  String _name;
  String _price;
  String _category;
  int _id;
  final Payment payment;

  EditPaymentState(this.payment);

  @override
  void initState() {
    super.initState();
    _id = this.payment.id;
    _name = this.payment.name;
    _price = this.payment.price.toString();
    _category = this.payment.category;
    _date = DateTime(this.payment.year, this.payment.month, this.payment.day);
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
        title: Text('Edit Payment'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0,0,0,5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 270.0,
                    child: TextFormField(
                      initialValue: _name,
                      decoration: new InputDecoration(
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
                      onSaved: (name) {
                        _name = name;
                      },
                      validator: (name) {
                        if (name == null || name.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 100.0,
                    child: TextFormField(
                      initialValue: _price,
                      decoration: new InputDecoration(
                        labelText: 'Price',
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
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp(r'^([0-9]{0,5}((.)[0-9]{0,2}))$')),
                      ],
                      onSaved: (price) {
                        _price = price;
                      },
                      validator: (price) {
                        if (price == null || price.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                    width: 170.0,
                    child: DateTimePickerFormField(
                      initialValue: _date,
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      firstDate: DateTime(2000, 1, 1),
                      initialDate: DateTime.now(),
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
                        //fillColor: Colors.green
                      ),
                      onSaved: (date) {
                        _date = date;
                      },
                      validator: (date) {
                        if (date == null) {
                          return '';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0),
              width: 270.0,
              height: 65,
              child: DropdownButtonFormField(
                value: _category,
                items: categoryList,
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                validator: (selected) {
                  if (selected == null) {
                    return '';
                  }
                  return null;
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
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5.0,0,0,5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: RaisedButton(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
                      onPressed: () {
                        _deleteById(_id);
                        Navigator.of(context).pop();
                      },
                      child: Text('Delete'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _update();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteById(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.delete(id);
  }

  void _update() async {
    Payment payment = new Payment();
    payment.id = _id;
    payment.name = _name;
    payment.category = _category;
    payment.price = double.parse(_price);
    payment.year = _date.year;
    payment.month = _date.month;
    payment.day = _date.day;
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.update(payment);
  }
}

class EditPayment extends StatefulWidget {
  final Payment payment;

  EditPayment(this.payment);

  @override
  EditPaymentState createState() => EditPaymentState(this.payment);
}