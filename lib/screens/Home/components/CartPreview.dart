import "package:flutter/material.dart";
import 'package:paperless_canteen/models/models.dart';
import 'package:paperless_canteen/providers/foodItem.dart';
import 'package:paperless_canteen/screens/Bill/BillScreen.dart';
import 'package:paperless_canteen/screens/Payment/PaymentScreen.dart';
import 'package:provider/provider.dart';

class CartPreviewWidget extends StatelessWidget {
  const CartPreviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foodItemsData = Provider.of<FoodItems>(context);
    final cartItems = foodItemsData.cartItems;
    return Container(
      height: MediaQuery.of(context).size.width * 1 / 3,
      child: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              // Swiping in right direction.
              if (details.delta.dy < 0) {
                openExtendedPreview(context);
              }
            },
            child: Image(
              image: AssetImage("assets/images/CartBG.png"),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(
                        "₹ " + foodItemsData.getCartTotal.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(235, 149, 49, 1),
                          borderRadius: BorderRadius.circular(22)),
                    ),
                    SizedBox(width: 13),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cart",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          cartItems.length.toString() + " items",
                          style: TextStyle(
                              color: Color(0xff8C8C8C),
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    openExtendedPreview(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      "View Cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(79, 255, 255, 255),
                      borderRadius: BorderRadius.circular(18),
                      // border: Border.all(width: 2, color: Colors.white),
                    ),
                  ),
                ),
                // CartItems()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> openExtendedPreview(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return OpenMenu();
      },
    );
  }
}

Widget CartItems() {
  final double size = 44;
  final imagePaths = [
    "assets/images/dosaImage.png",
    "assets/images/dosaImage.png",
    "assets/images/dosaImage.png",
    "assets/images/dosaImage.png",
  ];

  final items = imagePaths.map((imagePath) => buildImage(imagePath)).toList();

  return StackedWidgets(
    items: items,
    size: size,
  );
}

Widget buildImage(String imagePath) {
  final double borderSize = 1.2;

  return Container(
    decoration: BoxDecoration(
        border: Border.all(width: borderSize, color: Colors.white),
        borderRadius: BorderRadius.circular(22)),
    child: ClipOval(
      child: Image(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
  );
}

class StackedWidgets extends StatelessWidget {
  final List<Widget> items;
  final double size;

  const StackedWidgets({Key? key, required this.items, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final allItems = <Widget>[];
    for (int i = 0; i < 3; i++) {
      allItems.add(Container(
        margin: EdgeInsets.only(left: (21 * i).toDouble()),
        width: size,
        height: size,
        child: items[i],
      ));
    }
    if (items.length > 3)
      allItems.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: (21 * 3).toDouble()),
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(size / 2)),
        child: Text(
          "+" + (items.length - 3).toString(),
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ));
    return Stack(
      children: allItems,
    );
  }
}

// Widget OpenCartItems(itemDetails) {
//   return Container(
//     color: Color(0x0d0d0d),
//     child: Row(
//       children: ,
//     ),
//   );
// }
//write a function to calculate total cost

num calculateTotalCost(itemInfo) {
  num totalCost = 0;
  for (var i = 0; i < itemInfo.length; i++) {
    totalCost += itemInfo[i]["price"] * itemInfo[i]["quantity"];
  }
  return totalCost;
}

class OpenMenu extends StatelessWidget {
  OpenMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final foodItemsData = Provider.of<FoodItems>(context);

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Stack(
        children: [
          SizedBox(
            height: 500,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 25),
                      child: Text(
                        "Cart",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      //close button
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 20, right: 20),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                if (foodItemsData.cartItems.length == 0)
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                        "No items in cart",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                for (Item item in foodItemsData.cartItems)
                  OpenCartItem(item: item),
                SizedBox(height: 200)
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            height: 190,
            width: MediaQuery.of(context).size.width,
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(43),
                    topRight: Radius.circular(43)),
                color: Color(0xfff39b34),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Total",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xff251400),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(43),
                          topRight: Radius.circular(43)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 36, top: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFFDAAE),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        foodItemsData.cartItems.length
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "items",
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 30, top: 20),
                              height: 40,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromARGB(255, 255, 157, 45),
                                // border: Border.all(
                                //   color: Color(0xffFFDAAE),
                                //   width: 4,
                                // ),
                              ),
                              child: Center(
                                child: Text(
                                  "₹ " + foodItemsData.getCartTotal.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 190,
                          height: 55,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Color(0xffFFC698),
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: Color(0xffFF7200),
                              width: 3,
                            ),
                          ),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Order now",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Stack(
                                  children: [
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 15, color: Colors.black),
                                    Container(
                                      margin: EdgeInsets.only(left: 7),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentScreen()),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OpenCartItem extends StatefulWidget {
  OpenCartItem({required this.item, super.key});

  Item item;

  @override
  State<OpenCartItem> createState() => _OpenCartItemState();
}

class _OpenCartItemState extends State<OpenCartItem> {
  @override
  Widget build(BuildContext context) {
    final foodItemsData = Provider.of<FoodItems>(context);
    return Column(
      children: [
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 90,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Color.fromRGBO(55, 54, 54, 0.933),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        margin: EdgeInsets.only(left: 17),
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(widget.item.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              widget.item.category,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 102, 101, 101),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              widget.item.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              "₹" + widget.item.price.toString(),
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 114, 0, 0.6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 17, top: 13),
                            alignment: Alignment.center,
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color(0xff4B2900),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              "₹" +
                                  (widget.item.price * widget.item.itemCounter)
                                      .toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffFBA10F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 26,
                            width: 26,
                            margin: const EdgeInsets.only(
                                right: 10, bottom: 12, top: 7),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(width: 1, color: Colors.white),
                              color: Colors.black,
                            ),
                            alignment: Alignment.center,
                            child: MaterialButton(
                              padding: EdgeInsets.all(0),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () {
                                foodItemsData
                                    .decrementItemCounter(widget.item.id);
                              },
                            ),
                          ),
                          Text("x" + widget.item.itemCounter.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          Container(
                            height: 26,
                            width: 26,
                            margin: const EdgeInsets.only(
                                right: 15, left: 10, bottom: 12, top: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              ),
                              color: Colors.white,
                            ),
                            child: MaterialButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                foodItemsData
                                    .incrementItemCounter(widget.item.id);
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
