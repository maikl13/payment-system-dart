// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:michael_payment/manager/payment.dart';
import 'package:michael_payment/manager/payments_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'viewer/payment_viewer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: primaryColor,
    // navigation bar color
    statusBarColor: primaryColor, // status bar color
  ));
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [],
      supportedLocales: [
        const Locale('en', 'US'),
      ],
      home: michaelpaymentApp(),
    ),
  );
}

class michaelpaymentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return michaelpayment();
  }
}

class michaelpayment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Mymichaelpayment();
  }
}

const Color primaryColor = Color.fromRGBO(46, 45, 147, 1);

class Mymichaelpayment extends State<michaelpayment> {
  void openActivity(Payment payment) {
    print(payment.name);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductViewer(payment);
    }));
  }

  int current_section = 1;
  SimpleFontelicoProgressDialog? dialog;
  bool notLoading = true;

  void showLoading() {
    if (dialog != null && notLoading) {
      dialog!.show(message: "Please Wait...", type: SimpleFontelicoProgressDialogType.normal);
      notLoading = false;
    }
  }

  void hideLoading() {
    if (dialog != null) {
      dialog!.hide();
    }

    notLoading = true;
  }

  double lastPosition = 0.0;

  double distance = 0.0;

  ScrollController? controller;

  @override
  void initState() {
    controller = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      setState(() {
        if (dialog == null) {
          dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable: false);

          showLoading();
        }
      });
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "michael-payment",
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
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(toolbarHeight: 0, elevation: 0, systemOverlayStyle: const SystemUiOverlayStyle(systemNavigationBarIconBrightness: Brightness.light, statusBarColor: primaryColor, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light)),
          body: Material(
            child: Column(
              children: [
                Header(),
                TabBar(
                  indicatorColor: primaryColor,
                  tabs: [
                    Tab(
                        icon: Text(
                      "Remmittance",
                      style: TextStyle(color: Colors.grey[850], fontSize: 10),
                      textAlign: TextAlign.center,
                    )),
                    Tab(
                        icon: Text(
                      "Credit Card Payments",
                      style: TextStyle(color: Colors.grey[850], fontSize: 10),
                      textAlign: TextAlign.center,
                    )),
                    Tab(
                        icon: Text(
                      "Travel Card Reload",
                      style: TextStyle(color: Colors.grey[850], fontSize: 10),
                      textAlign: TextAlign.center,
                    )),
                    Tab(
                        icon: Text(
                      "Bill Payments",
                      style: TextStyle(color: Colors.grey[850], fontSize: 10),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
                Container(width: double.infinity, height: 1, color: Colors.grey),
                Container(
                  height: 0,
                  child: TabBarView(
                    children: [
                      Icon(Icons.directions_transit),
                      Icon(Icons.directions_transit),
                      Icon(Icons.directions_bike),
                      Icon(Icons.directions_bike)
                    ],
                  ),
                ),
                Expanded(
                    child:  paymentsList(this)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    double barHeight = 60.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(top: statusbarHeight),
          height: statusbarHeight + barHeight,
          child: Center(
            child: Text(
              "Transaction History",
              style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
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
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Row(children: [
              Container(
                child: Image(
                  width: 25,
                  height: 25,
                  image: AssetImage("images/back.png"),
                  color: Colors.white,
                  fit: BoxFit.scaleDown,
                ),
                margin: EdgeInsets.only(right: 10),
              )
            ]),
          ),
        ),
      ],
    );
  }
}
