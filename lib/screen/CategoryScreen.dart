import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_color/random_color.dart';

class ViewCategory extends StatefulWidget {
  @override
  _ViewCategoryState createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  final _cntrlContent = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _quote;
  RandomColor _randomColor = RandomColor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Category"),),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('category').snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.docs;
            return StaggeredGridView.countBuilder(
              scrollDirection: Axis.vertical,
              primary: false,
              crossAxisCount: 4,
              staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 1 : 1),
              itemCount: chatDocs.length,
              itemBuilder: (BuildContext context, int index) => new Container(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    color: _randomColor.randomColor().withOpacity(0.90),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:30,horizontal: 5),
                      child: AutoSizeText(
                        chatDocs[index]['category_name'],
                        style: TextStyle(color: Colors.white,fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            );
            // return ListView.builder(
            //   itemCount: chatDocs.length,
            //   itemBuilder: (ctx, index) => Card(
            //       margin: EdgeInsets.all(20),
            //       child: Padding(
            //           padding: EdgeInsets.all(20),
            //           child: Text(chatDocs[index]['category_name']))),
            //   // key:ValueKey(chatDocs[index]),
            //   // ),
            // );
          }),

    );
  }

}
