import 'package:flutter/material.dart';
import 'package:paperless_canteen/constants/items.dart';
import 'package:paperless_canteen/providers/foodItem.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';

class ItemCard extends StatefulWidget {
  ItemCard(
      {required this.id,
      required this.name,
      required this.category,
      required this.price,
      required this.imagePath,
      required this.itemCounter,
      super.key});

  String id;
  String name;
  String category;
  int price;
  String imagePath;
  int itemCounter;
  @override
  State<ItemCard> createState() => _ItemCardState();
}

Widget itemCardConstructor(Item item) {
  var itemCard = ItemCard(
      id: item.id,
      name: item.name,
      category: item.category,
      price: item.price,
      imagePath: item.imagePath,
      itemCounter: item.itemCounter);

  return itemCard;
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    final foodItemsData = Provider.of<FoodItems>(context);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 168,
        height: 210,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(widget.imagePath))),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Container(
                      width: 28,
                      height: 76,
                      child: Image(
                          image: AssetImage(
                              "assets/images/counterRemoveImage.png")),
                    ),
                    onTap: () {
                      setState(() {
                        if (widget.itemCounter > 0)
                          foodItemsData.decrementItemCounter(widget.id);
                      });
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      width: 28,
                      height: 76,
                      child: Image(
                          image:
                              AssetImage("assets/images/counterAddImage.png")),
                    ),
                    onTap: () {
                      setState(() {
                        foodItemsData.incrementItemCounter(widget.id);
                      });
                    },
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 26),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 9),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            width: 54,
                            height: 24,
                            alignment: Alignment.center,
                            child: Text(
                              widget.category,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(33),
                                color: Colors.white.withOpacity(0.85)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 18),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          alignment: Alignment.center,
                          child: Text(
                            "₹ " + widget.price.toString(),
                            style: TextStyle(
                                color: Color(0xffFFBC3A),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(33),
                              color: Color.fromARGB(255, 86, 47, 0)),
                        ),
                      ],
                    )
                  ],
                ),
                widget.itemCounter == 0
                    ? GestureDetector(
                        child: AddButton(),
                        onTap: () {
                          setState(() {
                            foodItemsData.incrementItemCounter(widget.id);
                          });
                        },
                      )
                    : CounterWidget(
                        itemCounter: widget.itemCounter,
                      )
              ],
            ),
          ],
        ));
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          child: Text(
            "ADD",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(33),
              color: Colors.white.withOpacity(0.95)),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

class CounterWidget extends StatefulWidget {
  CounterWidget({required this.itemCounter, super.key});

  int itemCounter;
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 65,
          width: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 43,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Text(
                    "Added",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      color: Colors.black),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  "x " + widget.itemCounter.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    color: Colors.white.withOpacity(0.95)),
              ),
            ],
          ),
        ),
        SizedBox(height: 22),
      ],
    );
  }
}
