import 'package:flutter/material.dart';
import 'package:flutter_quotebook/screen/add_category.dart';
import 'package:flutter_quotebook/screen/add_quote.dart';
class YourQuote extends StatefulWidget {
  @override
  _YourQuoteState createState() => _YourQuoteState();
}

class _YourQuoteState extends State<YourQuote> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: Text('Add your quotes'),
          ),
        body: AddQuote(),
      ),
    );
  }
}
