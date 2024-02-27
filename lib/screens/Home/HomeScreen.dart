import 'package:flutter/material.dart';
import 'package:paperless_canteen/main.dart';
import 'package:paperless_canteen/providers/foodItem.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import 'components/CartPreview.dart';
import 'components/ItemCard.dart';
import '../Search/SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool orderNowSelected = true;
  bool profileSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        primary: true,
        backgroundColor: Color.fromARGB(255, 255, 237, 147),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10),
            icon: Image(
              image: AssetImage("assets/icons/drawerIcon.png"),
              width: 27,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          "PSG College of Technology",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Image(
                image: AssetImage("assets/icons/searchIcon.png"),
                width: 36,
              ),
              onPressed: () {
                print("Search button pressed");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    SizedBox(width: 30),
                    ChoiceChip(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        label: Text("Order Now",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: orderNowSelected
                                    ? Colors.white
                                    : Colors.black)),
                        selected: orderNowSelected,
                        selectedColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black, width: 1),
                        onSelected: (bool selected) {
                          setState(() {
                            orderNowSelected = selected;
                          });
                        }),
                    SizedBox(width: 10),
                    ChoiceChip(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        label: Text("View Bills",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: profileSelected
                                    ? Colors.white
                                    : Colors.black)),
                        selected: profileSelected,
                        selectedColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black, width: 1),
                        onSelected: (bool selected) {
                          if (selected) {
                            Navigator.of(context).pushNamed("/view-bills");
                          }
                        }),
                    SizedBox(width: 10),
                    ChoiceChip(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        label: Text("Profile",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: profileSelected
                                    ? Colors.white
                                    : Colors.black)),
                        selected: profileSelected,
                        selectedColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black, width: 1),
                        onSelected: (bool selected) {
                          if (selected) {
                            Navigator.of(context).pushNamed("/profile");
                          }
                        }),
                  ]),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 30),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "CATEGORIES",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2),
                  ),
                ),
                BuildItemsWidget(),
                SizedBox(height: 200)
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: CartPreviewWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildItemsWidget extends StatelessWidget {
  const BuildItemsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<FoodItems>(context);
    final items = itemsData.items;
    return Column(
      children: [
        // ItemsCategory(title: "Bakery 2", itemsList: items),
        // SizedBox(height: 10),
        ItemsCategory(title: "Tiffin", itemsList: items),
        SizedBox(height: 10),
        ItemsCategory(title: "Your Mom", itemsList: items),
      ],
    );
  }
}

class ItemsCategory extends StatelessWidget {
  String title;
  List<Item> itemsList;

  ItemsCategory({Key? key, required this.itemsList, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CategorySubheadingWatermark(title: title),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 55),
            CategorySubheadingWidget(title: title),
            SizedBox(height: 10),
            CardsListViewWidget(itemsList: itemsList),
          ],
        )
      ],
    );
  }
}

class CardsListViewWidget extends StatelessWidget {
  List<Item> itemsList;

  CardsListViewWidget({Key? key, required this.itemsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 40),
        itemCount: itemsList.length,
        physics: PageScrollPhysics(),
        itemBuilder: (context, index) => itemCardConstructor(itemsList[index]),
      ),
    );
  }
}

class CategorySubheadingWatermark extends StatelessWidget {
  String title;

  CategorySubheadingWatermark({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: Color(0xffE7E7E7),
          fontFamily: "Spicy Chicken",
          fontSize: 120,
          fontWeight: FontWeight.w400),
    );
  }
}

class CategorySubheadingWidget extends StatelessWidget {
  CategorySubheadingWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 32),
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: Colors.black,
      ),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}
