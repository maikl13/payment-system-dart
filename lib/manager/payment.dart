import 'package:flutter/services.dart';

class Payment{


  String name="",bank_name="", transfer_type="",reference_number="",cf_number="",payout_location="",account_number="" , id="";
  int receiving_amount=0,paid_amount=0,createdAt=0;
  bool status = false;
  String image = "https://www.worldatlas.com/r/w960-q80/img/flag/pk-flag.jpg";

Payment.empty(){

}

  Payment(Map<String, dynamic> jsonObject ){
    this.name = jsonObject["name"];
    this.bank_name = jsonObject["bank_name"];
    this.transfer_type = jsonObject["transfer_type"];
    this.reference_number = jsonObject["reference_number"];
    this.cf_number = jsonObject["cf_number"];
    this.payout_location = jsonObject["payout_location"];
    this.account_number = jsonObject["account_number"];
this.createdAt = jsonObject["createdAt"];

    this.receiving_amount = jsonObject["receiving_amount"];
    this.paid_amount = jsonObject["paid_amount"];
    this.status = jsonObject["status"];


  }

}