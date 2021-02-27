import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter_quotebook/screen/your_quote.dart';
import 'package:flutter_quotebook/utils/UtilsImporter.dart';
import 'package:flutter_quotebook/screen/HomeScreen.dart';
import 'package:flutter_quotebook/screen/CategoryScreen.dart';
import 'package:flutter_quotebook/screen/ProfileScreen.dart';
import 'package:flutter_quotebook/screen/FavoriteScreen.dart';

import 'my_quotes_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex;
  Widget widgetForBody = HomeScreen();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return YourQuote();
          }));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end,
        //new
        hasNotch: true,
        //new
        hasInk: true,
        //new, gives a cute ink effect
        inkColor: Colors.black12,
        //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          UtilsImporter().widgetUtils.bottomItem(
              UtilsImporter().stringUtils.bottomMenuHome, Icons.home),
          UtilsImporter().widgetUtils.bottomItem(
              UtilsImporter().stringUtils.bottomMenuCategory, Icons.category),
          UtilsImporter().widgetUtils.bottomItem(
              UtilsImporter().stringUtils.bottomMenuFavorite, Icons.favorite),
        ],
      ),
      body: widgetForBody,
    );
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      clickBottmenu(currentIndex);
    });
  }

  void clickBottmenu(int index) {
    switch (currentIndex) {
      case 0:
        widgetForBody = HomeScreen();
        break;
      case 1:
        widgetForBody = ViewCategory();
        break;

      // case 3:
      //   widgetForBody=AddCategory();
    }
  }
}
