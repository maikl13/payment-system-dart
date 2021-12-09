import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:michael_payment/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:michael_payment/manager/payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import "dart:convert" show utf8;


Color primaryColor = Color.fromARGB(255, 115, 171, 66);

class paymentsList extends StatefulWidget {
  Mymichaelpayment? app;

  paymentsList(Mymichaelpayment app) {
    this.app = app;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return paymentsState(app!);
  }
}

int selected = 0;

class paymentsState extends State<paymentsList> {
  List<Payment> payments = <Payment>[];
  Mymichaelpayment? app;

  paymentsState(Mymichaelpayment app) {
    this.app = app;
  }

  int lastSection = -1;

  @override
  Widget build(BuildContext context) {
    if (lastSection != app!.current_section) {
      lastSection = app!.current_section;
      updateListView(lastSection);
    }

    // TODO: implement build
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(right: 15, left: 15),
      child: StaggeredGridView.countBuilder(
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          crossAxisCount: 1,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 25.0,
          itemCount: payments.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                app!.openActivity(payments[i]);
              },
              child: Container(
                width: double.infinity,
                color: i.isEven ? Color.fromRGBO(248, 249, 250, 1) : Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          imageUrl: payments[i].image,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                direction: Axis.vertical,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 15, bottom: 5),
                                      child: Text(
                                        payments[i].name.toUpperCase(),
                                        maxLines: 1,
                                        style: TextStyle(color: Color.fromRGBO(86, 110, 207, 1), fontSize: 15, fontFamily: "futura_medium_bt"),
                                      )),
                                  Text(
                                    payments[i].bank_name.toUpperCase(),
                                    style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "futura_medium_bt"),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 18, bottom: 20),
                                      child: Wrap(
                                        children: [
                                          Text(
                                            payments[i].transfer_type,
                                            maxLines: 1,
                                            style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 12, fontFamily: "futura_medium_bt"),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Container(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              payments[i].paid_amount.toString(),
                              maxLines: 1,
                              style: TextStyle(color: Color.fromRGBO(53, 66, 156, 1), fontSize: 20, fontFamily: "futura_medium_bt"),
                            ),
                            Text(
                              "PKR",
                              maxLines: 1,
                              style: TextStyle(color: Color.fromRGBO(53, 66, 156, 1), fontSize: 12, fontFamily: "futura_medium_bt"),
                            )
                          ],
                        )),

                        Container(
                          margin: EdgeInsets.only(top: 10 , bottom: 10),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(payments[i].createdAt * 1000)),
                            maxLines: 1,
                            style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 12, fontFamily: "futura_medium_bt"),

                          ),

                        ),
                        Image(
                          image: AssetImage(payments[i].status?"images/correct.png" : "images/wrong.png"),

                            width: 20.0,
                            height: 20.0,

                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  void updateListView(int i) async {
    List<Payment> newList = <Payment>[];
    var url = "https://61769aed03178d00173dad89.mockapi.io/api/v1/transactions";

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var string = utf8.decode(response.bodyBytes);

      List<dynamic> list = convert.jsonDecode(string);

      int i =0;
      list.forEach((element) {
        i++;

        Payment payment = Payment(element);
        if(i==2){
          payment.status=true;
        }
        newList.add(payment);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    setState(() {
      this.payments = newList;
      if (app != null) {
        app!.hideLoading();
      }
    });
  }

  Future<void> stackHelp() async {}
}
