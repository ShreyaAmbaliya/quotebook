import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quotebook/screen/my_quotes_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Home.dart';
import 'add_category.dart';

class AddQuote extends StatefulWidget {
  @override
  _AddQuoteState createState() => _AddQuoteState();
}

class _AddQuoteState extends State<AddQuote> {
  final _cntrlContent = TextEditingController();

  final _cntrlCategory = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  String dropdownValue = 'One';
  String _quote;
  String _myActivity;
  String _myActivityResult;

  @override
  void initState() {
    super.initState();
    setState(() {
      getCategory();
    });
    // setState(() {
    //   _myActivity = '';
    // });
  }

  List<String> cat = [];

  List<String> allCategory;

  getCategory() async {
    log("get category function");
    FirebaseFirestore.instance
        .collection('category')
        .snapshots()
        .listen((data) {
      data.docs.forEach((document) {
        cat.add(document['category_name']);
      });
      print("**allcategory**");
      setState(() {
        allCategory = cat;
      });

      print(allCategory.toString());
      print(allCategory.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [_form()],
    ));
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Expanded(
          child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton(
                      value: _myActivity,
                      isDense: true,
                      onChanged: (String newValue) {
                        // debugPrint('makeModel selected: $value');
                        setState(
                          () {
                            print('*******************$newValue');
                            // Selected value will be stored
                            _myActivity = newValue;
                            // Default dropdown value won't be displayed anymore
                          },
                        );
                      },
                      items: allCategory.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _cntrlContent.clear();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      _Categoryform(),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(35.0)),
                                  ));
                            });
                      },
                      child: Text("Add Category"),
                    )
                  ])),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border:
                    Border.all(color: Colors.black.withOpacity(0.2), width: 2),
              ),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLines: 5,
                    maxLength: 500,
                    style: TextStyle(fontSize: 15),
                    controller: _cntrlContent,
                    decoration: InputDecoration(
                      hintText: 'Quote here',
                      labelStyle: TextStyle(
                          color: Colors.black, letterSpacing: 2, fontSize: 15),
                      border: InputBorder.none,
                      errorStyle: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    onSaved: (val) => setState(() {
                      _quote = val;
                    }),
                    validator: (val) =>
                        (val.length == 0 ? 'This field is required' : null),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                FlatButton(
                  padding: EdgeInsets.all(15),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Add Quote',
                    style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                  splashColor: Colors.black,
                  color: Colors.cyan,
                  textColor: Colors.white.withOpacity(0.9),
                  onPressed: () {
                    _onSubmit();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  padding: EdgeInsets.all(15),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  splashColor: Colors.redAccent,
                  color: Colors.black.withOpacity(0.4),
                  textColor: Colors.white.withOpacity(0.9),
                  onPressed: () {
                    // _resetForm();
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  _onSubmit() async {
    var response=await FirebaseFirestore.instance
        .collection('quotes')
        .doc(DateTime.now().toString())
        .set({'quote': _cntrlContent.text, 'category_name': _myActivity});

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Home(),
    ));
  }

  _Categoryform() => Container(
      height: 320,
      width: 260,
      padding: EdgeInsets.only(top: 40, bottom: 20, left: 0, right: 0),
      child: Form(
        key: _formKey1,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border:
                    Border.all(color: Colors.black.withOpacity(0.2), width: 2),
              ),
              child: TextFormField(
                maxLines: 5,
                style: TextStyle(fontSize: 15),
                controller: _cntrlCategory,
                decoration: InputDecoration(
                  hintText: 'Category',
                  labelStyle: TextStyle(
                      color: Colors.black, letterSpacing: 2, fontSize: 15),
                  border: InputBorder.none,
                  errorStyle: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                onSaved: (val) => setState(() {
                  _quote = val;
                }),
                validator: (val) =>
                    (val.length == 0 ? 'This field is required' : null),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(15),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Add Quote',
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                    splashColor: Colors.black,
                    color: Colors.cyan,
                    textColor: Colors.white.withOpacity(0.9),
                    onPressed: () {
                      _onSubmitCategory();
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(15),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    splashColor: Colors.redAccent,
                    color: Colors.black.withOpacity(0.4),
                    textColor: Colors.white.withOpacity(0.9),
                    onPressed: () {
                      // _resetForm();
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ));

  _onSubmitCategory() async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(DateTime.now().toString())
        .set({
      'category_name': _cntrlCategory.text,
    }).then((value) {
      print("*****");
      allCategory = [];
      cat = [];
      getCategory();
      // Fluttertoast.showToast(
      //     msg: 'Category Created', toastLength: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
    });
  }
}
