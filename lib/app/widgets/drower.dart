import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../home/view/home.dart';
import '../pending_ question/view/pending_question.dart';
import '../settings/view/setting_view.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipOval(
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: context.screenHeight * .12,
                    height: context.screenHeight * .12,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(context.screenHeight * .06),
                    ),
                    child: Image.asset(
                      'assets/icons/profile.png',
                      width: context.screenHeight * .12,
                      height: context.screenHeight * .12,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                "Super Admin".text.make()
              ],
            ),
          )),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () {
              Get.to(() => const HomeScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Pending Question',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Get.to(() => const PendingQuestions());
            },
          ),
          ListTile(
            leading: const Icon(Icons.wallet),
            title: const Text('Wallet'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text('Privacy policy'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.comment),
            title: const Text('Terms & condition'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Get.to(() => const SettingView());
            },
          ),
        ],
      ),
    );
  }
}
