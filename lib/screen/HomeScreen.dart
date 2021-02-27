import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:random_color/random_color.dart';

class HomeScreen extends StatelessWidget {
  RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('your quotes')),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('quotes').snapshots(),
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
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              itemCount: chatDocs.length,
              staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 3 : 2),
              itemBuilder: (BuildContext context, int index) => new Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(26.0),

                    child: AutoSizeText(
                      chatDocs[index]['quote'],
                      style: TextStyle(color:_randomColor.randomColor(),fontSize: 30),
                    ),


                  ),
                ),
              ),
            );
          }),
    );
  }
}
