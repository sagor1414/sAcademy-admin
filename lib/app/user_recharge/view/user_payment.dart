import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../user_recharge_details/view/user_payment_details.dart';
import '../controller/user_payment_controller.dart';

class PendingUserPayment extends StatelessWidget {
  const PendingUserPayment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    UserPaymentController controller = Get.put(UserPaymentController());
    return Scaffold(
      backgroundColor: const Color(0xff4db6e7),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 160, 206),
        elevation: 2,
        title: const Text("User recharge"),
      ),
      body: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !controller.loadingMore.value) {
            // Fetch more data when the user reaches the end of the list
            controller.fetchMoreData();
            log("fetching more data");
          }
          return false;
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            20.heightBox,
            Obx(
              () => controller.questionlist.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            60.heightBox,
                            Text(
                              "You Don't have any pending Payment",
                              style: TextStyle(
                                  fontSize: context.screenWidth * .06,
                                  fontWeight: FontWeight.w500),
                            ),
                            Image.asset(
                              'assets/images/empty.png',
                              width: context.screenWidth * .7,
                            )
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.questionlist.length,
                      itemBuilder: (context, index) {
                        var paymentdata = controller.questionlist[index].data();
                        return Container(
                          padding: const EdgeInsets.all(8),
                          margin: EdgeInsets.only(
                            left: context.screenWidth * .05,
                            right: context.screenWidth * .05,
                            bottom: context.screenWidth * .04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                          child: ListTile(
                            onTap: () {
                              Get.to(() => UserPaymentDetails(
                                    paymentData: paymentdata,
                                  ));
                            },
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Amount: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: context.screenWidth * .012,
                                      ),
                                      Text(
                                        "${paymentdata['rechargeAmount']}",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            title: Row(
                              children: [
                                const Text(
                                  "Payment method: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${paymentdata['paymentMethod']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Obx(
              () => Center(
                child: controller.loadingMore.value
                    ? const CircularProgressIndicator()
                    : null,
              ),
            ),
            20.heightBox,
          ],
        ),
      ),
    );
  }
}
