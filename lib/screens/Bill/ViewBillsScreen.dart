import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperless_canteen/models/models.dart';
import 'package:paperless_canteen/providers/foodItem.dart';
import 'package:paperless_canteen/screens/Bill/BillScreen.dart';
import 'package:provider/provider.dart';

import 'Components/CustomAppBar.dart';

class ViewBillsScreen extends StatefulWidget {
  const ViewBillsScreen({super.key});

  @override
  State<ViewBillsScreen> createState() => _ViewBillsScreenState();
}

class _ViewBillsScreenState extends State<ViewBillsScreen> {
  @override
  Widget build(BuildContext context) {
    final foodItemsData = Provider.of<FoodItems>(context);
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            children: [
              CustomAppBar(),
              CustomNavigationBar(),

              // Bills Heading
              _Heading(title: "All Bills"),

              if (foodItemsData.bills.isEmpty)
                Center(
                    child: Text(
                  "No Bills Available",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black38),
                )),

              for (Bill bill in foodItemsData.bills) AvailableBill(bill: bill),

              SizedBox(height: 15),

              _Heading(title: "Previous Orders"),

              if (foodItemsData.previousBills.isEmpty)
                Center(
                  child: Text(
                    "No Previous Orders Available",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black38),
                  ),
                ),
              for (Bill bill in foodItemsData.previousBills)
                PreviousOrderBill(bill: bill),
              SizedBox(height: 50),
            ],
          )),
    );
  }
}

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    bool orderNowSelected = false;
    bool profileSelected = false;
    bool viewBillsSelected = true;
    return Container(
      width: double.infinity,
      height: 50,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        SizedBox(width: 30),
        ChoiceChip(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            label: Text("Order Now",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: orderNowSelected ? Colors.white : Colors.black)),
            selected: orderNowSelected,
            selectedColor: Colors.black,
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.black, width: 1),
            onSelected: (bool selected) {
              Navigator.popUntil(
                context,
                (route) => Navigator.canPop(context),
              );
              Navigator.of(context).pushReplacementNamed("/home");
            }),
        SizedBox(width: 10),
        ChoiceChip(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            label: Text("Orders",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: viewBillsSelected ? Colors.white : Colors.black)),
            selected: viewBillsSelected,
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
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            label: Text("Profile",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: profileSelected ? Colors.white : Colors.black)),
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
    );
  }
}

class _Heading extends StatelessWidget {
  _Heading({
    Key? key,
    required this.title,
  }) : super(key: key);

  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 7, left: 36, bottom: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }
}

class AvailableBill extends StatefulWidget {
  AvailableBill({super.key, required this.bill});

  Bill bill;

  @override
  State<AvailableBill> createState() => _AvailableBillState();
}

class _AvailableBillState extends State<AvailableBill> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BillScreen(
              bill: widget.bill,
              isClaimed: false,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 22, right: 22, bottom: 14),
        decoration: BoxDecoration(
          color: Color(0xffFFFBF8),
          // color: Colors.black,
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: Color.fromARGB(255, 255, 235, 213), width: 4),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Column(
                  children: [
                    SizedBox(height: 18),
                    Container(
                      width: 62,
                      height: 57,
                      child: Stack(
                        children: [
                          Container(
                            child: Text(widget.bill.counterId.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                )),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xffFFC698),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          Positioned(
                            top: 35,
                            child: Container(
                              child: Text(
                                "Counter",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 11),
                    Text(
                      widget.bill.items.length.toString() + " items",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bill from",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff4B2900).withOpacity(0.24),
                              ),
                            ),
                            Text(
                              widget.bill.dateTime,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Stack(
                          children: [
                            Positioned(
                              top: 3,
                              left: 3,
                              child: Container(
                                margin: EdgeInsets.only(left: 3, top: 3),
                                child: Text(
                                    "₹ " + widget.bill.totalPrice.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    )),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 17,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xffFDC461),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            Container(
                              child:
                                  Text("₹ " + widget.bill.totalPrice.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      )),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              margin: EdgeInsets.only(right: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Color(0xffFFDA94),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Color(0xffFFC698),
                                  width: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    for (Item item in widget.bill.items) BillItem(item: item),
                    SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 56),
                    Text(
                      "Tiffin",
                      style: TextStyle(
                        fontSize: 46,
                        fontFamily: "Spicy Chicken",
                        color: Colors.black12,
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BillItem extends StatelessWidget {
  BillItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            item.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 17),
          Text(
            "x " + item.itemCounter.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xffD48120),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Color(0xffFFEBC3),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class PreviousBillItem extends StatelessWidget {
  PreviousBillItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            item.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 17),
          Text(
            "x " + item.itemCounter.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xff8A8A8A),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Color(0xffE4E4E4),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class PreviousOrderBill extends StatefulWidget {
  PreviousOrderBill({super.key, required this.bill});

  Bill bill;

  @override
  State<PreviousOrderBill> createState() => _PreviousOrderBillState();
}

class _PreviousOrderBillState extends State<PreviousOrderBill> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BillScreen(bill: widget.bill, isClaimed: true),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 22, right: 22, bottom: 14),
        decoration: BoxDecoration(
          color: Color(0xffF8F8F8),
          // color: Colors.black,
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: Color.fromARGB(255, 224, 224, 224), width: 4),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Column(
                  children: [
                    SizedBox(height: 18),
                    Container(
                      width: 62,
                      height: 57,
                      child: Stack(
                        children: [
                          Container(
                            child: Text("4",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                )),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xffD4D4D4),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          Positioned(
                            top: 35,
                            child: Container(
                              child: Text(
                                "Counter",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 11),
                    Text(
                      "2 items",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bill from",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff4B2900).withOpacity(0.24),
                              ),
                            ),
                            Text(
                              "12 Mar, 2023 12:24 PM",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.125,
                        ),
                        Stack(
                          children: [
                            Positioned(
                              top: 3,
                              left: 3,
                              child: Container(
                                margin: EdgeInsets.only(left: 3, top: 3),
                                child: Text("₹ 100",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    )),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 17,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff909090),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            Container(
                              child: Text("₹ 100",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  )),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              margin: EdgeInsets.only(right: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Color(0xff909090),
                                  width: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Ghee Roast",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 17),
                          Text(
                            "x 2",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff8A8A8A),
                            ),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffE4E4E4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Ghee Roast",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 17),
                          Text(
                            "x 2",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff8A8A8A),
                            ),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffE4E4E4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 56),
                    Text(
                      "Tiffin",
                      style: TextStyle(
                        fontSize: 46,
                        fontFamily: "Spicy Chicken",
                        color: Colors.black12,
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
