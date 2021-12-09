// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:michael_payment/manager/payment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import "dart:convert" show utf8;
import 'package:intl/intl.dart';
import 'package:michael_payment/manager/payments_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class ProductViewerApp extends StatelessWidget {
  Payment? payment;

  ProductViewerApp(Payment payment) {
    this.payment = payment;
  }

  @override
  Widget build(BuildContext context) {
    return ProductViewer(payment!);
  }
}

class ProductViewer extends StatefulWidget {
  Payment? payment;

  ProductViewer(Payment payment) {
    this.payment = payment;
  }

  @override
  State<StatefulWidget> createState() {
    return MyProductViewer(payment!);
  }
}

const Color primaryColor = Color.fromRGBO(46, 45, 147, 1);

class MyProductViewer extends State<ProductViewer> {
  Payment payment = Payment.empty();

  void reloadPayment() async {
    var url = "https://61769aed03178d00173dad89.mockapi.io/api/v1/transactions/" + payment.id;

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var string = utf8.decode(response.bodyBytes);

      Map<String, dynamic> element = convert.jsonDecode(string);

      payment = Payment(element);
      setState(() {
        payment = Payment(element);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  MyProductViewer(Payment payment) {
    this.payment = payment;

    reloadPayment();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "michael-Payment",
      theme: ThemeData(
        // Define the default brightness and colors.
        primarySwatch: Colors.blue,
        primaryColor: primaryColor,
        primaryColorDark: Colors.black,
        fontFamily: 'Georgia',
        accentColor: primaryColor,
        backgroundColor: primaryColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(bodyColor: primaryColor, displayColor: primaryColor),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(toolbarHeight: 0, elevation: 0, systemOverlayStyle: const SystemUiOverlayStyle(systemNavigationBarIconBrightness: Brightness.light, statusBarColor: primaryColor, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light)),
        body: Material(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              SingleChildScrollView(
                child: Column(
                  children: [
                    Header(context,payment),
                    Container(
                      margin: EdgeInsets.only(top: 80),
                      child: Image(
                        image: AssetImage(payment.status ? "images/correct.png" : "images/wrong.png"),
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15),
                        alignment: Alignment.center,
                        child: Text(
                          payment.status ? "Transaction Completed" : "Transaction Faild",
                          maxLines: 1,
                          style: TextStyle(color: payment.status ? Colors.greenAccent : Colors.redAccent, fontSize: 30, fontFamily: "futura_bold_font"),
                        )),

                  ],
                ),
              ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30, right: 10, left: 10, bottom: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.grey[300]!
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 0.5),
                        stops: [
                          0.0,
                          1.0
                        ],
                        tileMode: TileMode.clamp),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(width: 0.3, color: Colors.grey),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.end,
                                  runAlignment: WrapAlignment.end,
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  verticalDirection: VerticalDirection.down,
                                  children: [
                                    Text(
                                      payment.receiving_amount.toString(),
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.green, fontSize: 30, fontFamily: "futura_medium_bt"),
                                    ),
                                    Text(
                                      "PKR",
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "futura_medium_bt"),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    "Receiving amount",
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 15, fontFamily: "futura_medium_bt"),
                                  ),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(width: 0.3, color: Colors.grey),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.end,
                                  runAlignment: WrapAlignment.end,
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  verticalDirection: VerticalDirection.down,
                                  children: [
                                    Text(
                                      payment.paid_amount.toString(),
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.redAccent, fontSize: 30, fontFamily: "futura_medium_bt"),
                                    ),
                                    Text(
                                      "AED",
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: "futura_medium_bt"),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    "Total paid",
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 15, fontFamily: "futura_medium_bt"),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 20),

                  child: Row(

                    children: <Widget>[
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            child: ElevatedButton(
                              child: Text("New Transaction".toUpperCase()),
                              onPressed: () => print("it's pressed"),
                              style: ElevatedButton.styleFrom(
                                primary: primaryColor,
                                onPrimary: Colors.white,
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                shape: StadiumBorder(),
                              ),
                            ),
                          )),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            child: ElevatedButton(
                              child: Text(
                                "Send Receipt".toUpperCase(),
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              onPressed: () => print("it's pressed"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[400],
                                onPrimary: Colors.white,
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                shape: StadiumBorder(),
                              ),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            )
            ],),


        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  Payment payment = Payment.empty();
  BuildContext? app;
  Header(BuildContext app,Payment payment) {
    this.app=app;
    this.payment = payment;
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  "Transaction Details",
                  style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Row(children: [
                      Container(
                        child: GestureDetector(

                          onTap: () {
                            if (Navigator.canPop(app!)) {
                              Navigator.pop(app!);
                            } else {
                              SystemNavigator.pop();
                            }
                          },
                          child: Image(
                            width: 25,
                            height: 25,
                            image: AssetImage("images/back.png"),
                            color: Colors.white,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        margin: EdgeInsets.only(right: 10),
                      )
                    ]),
                  ),
                )
              ],
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(width: 0.6, color: Colors.grey),
                            bottom: BorderSide(width: 0.6, color: Colors.grey),
                            left: BorderSide(width: 0.6, color: Colors.grey),
                            right: BorderSide(width: 0.3, color: Colors.grey),
                          )),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "transfer reference number",
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(payment.reference_number, style: TextStyle(color: primaryColor, fontSize: 16), maxLines: 1),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(width: 0.6, color: Colors.grey),
                            bottom: BorderSide(width: 0.6, color: Colors.grey),
                            left: BorderSide(width: 0.3, color: Colors.grey),
                            right: BorderSide(width: 0.6, color: Colors.grey),
                          )),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CE Number",
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(payment.cf_number, style: TextStyle(color: Colors.black, fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 0.6, color: Colors.grey),
                      left: BorderSide(width: 0.3, color: Colors.grey),
                      right: BorderSide(width: 0.6, color: Colors.grey),
                    )),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Beneficiary name",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(payment.name, style: TextStyle(color: Colors.black, fontSize: 17)),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(width: 0.6, color: Colors.grey),
                            left: BorderSide(width: 0.6, color: Colors.grey),
                            right: BorderSide(width: 0.3, color: Colors.grey),
                          )),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Beneficiary Bank/Agent",
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(payment.bank_name, style: TextStyle(color: Colors.black, fontSize: 17)),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(width: 0.6, color: Colors.grey),
                            left: BorderSide(width: 0.3, color: Colors.grey),
                            right: BorderSide(width: 0.6, color: Colors.grey),
                          )),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payout Location",
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text("NA", style: TextStyle(color: Colors.black, fontSize: 17)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(width: 0.6, color: Colors.grey),
                            left: BorderSide(width: 0.6, color: Colors.grey),
                            right: BorderSide(width: 0.3, color: Colors.grey),
                          )),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account number",
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(payment.account_number, style: TextStyle(color: Colors.black, fontSize: 17)),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(width: 0.6, color: Colors.grey),
                            left: BorderSide(width: 0.3, color: Colors.grey),
                            right: BorderSide(width: 0.6, color: Colors.grey),
                          )),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payment date",
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(payment.createdAt * 1000)), style: TextStyle(color: Colors.black, fontSize: 17)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color.fromRGBO(79, 137, 219, 1),
              primaryColor
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [
              0.0,
              1.0
            ],
            tileMode: TileMode.clamp),
      ),
    );
  }
}
