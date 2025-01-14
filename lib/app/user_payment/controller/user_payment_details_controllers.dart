import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class UserPaymentDetailsCOntrollers extends GetxController {
  var isloading = false.obs;
  var isloadings = false.obs;
  var balance = 0.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getuserinfo(var paymentdatas) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDocSnapshot =
          await _firestore.collection('users').doc(paymentdatas['uid']).get();

      String balanceString = userDocSnapshot['balance'].toString();
      int balanceInt = int.parse(balanceString);
      balance.value = balanceInt;
      print("Current balance: \$${balance.value}");
    }
  }

  acceptPayment(context, var paymentdatas) async {
    try {
      isloading(true);
      Map<String, dynamic> acceptpayment = {
        'amount': paymentdatas['rechargeAmount'],
        'number': paymentdatas['transactionNumber'],
        'status': 'accepted',
        'uid': paymentdatas['uid'],
        'time': paymentdatas['time'],
        'timestamp': paymentdatas['timestamp'],
      };

      await FirebaseFirestore.instance
          .collection('alltransaction')
          .doc(paymentdatas['timestamp'])
          .set(acceptpayment)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(paymentdatas['uid'])
            .collection('transaction')
            .doc(paymentdatas['timestamp'])
            .update({'status': 'accepted'}).then((value) async {
          await FirebaseFirestore.instance
              .collection('userwithdraw')
              .doc(paymentdatas['timestamp'])
              .delete();
        });

        Get.snackbar(
          "sucessfull",
          "Payment Accepted Sucessfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      });

      log('Accept Sucessfull');
      isloading(false);
    } catch (e) {
      log('Error is : $e');
      isloading(false);
    }
  }

  rejectPayment(context, var paymentdatas) async {
    try {
      isloadings.value = true;
      int rechargeAmount = paymentdatas['rechargeAmount'] is double
          ? (paymentdatas['rechargeAmount'] as double).toInt()
          : int.parse(paymentdatas['rechargeAmount'].toString());

      int updatedBalance = balance.value + rechargeAmount;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(paymentdatas['uid'])
          .collection('transaction')
          .doc(paymentdatas['timestamp'])
          .update({'status': 'rejected'}).then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(paymentdatas['uid'])
            .update({'balance': updatedBalance.toString()});
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('userwithdraw')
            .doc(paymentdatas['timestamp'])
            .delete();
        isloadings.value = false;
      });
    } catch (e) {
      isloadings.value = false;
      VxToast.show(context, msg: "Try after some time");
    }
  }
}
