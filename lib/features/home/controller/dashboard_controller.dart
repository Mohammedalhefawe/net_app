import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web1/features/home/view/screens/files_screen.dart';
import 'package:web1/features/home/view/screens/groups_screen.dart';
import 'package:web1/features/home/view/screens/home_screen.dart';
import 'package:web1/features/home/view/screens/notification_screen.dart';
import 'package:web1/features/home/view/screens/settings_screen.dart';
import 'package:web1/features/home/view/widgets/info_section_widget.dart';

class DashboardController extends GetxController {
  int hoveredIndex = 0;
  int selectedScreenIndex = 0;
  List<Widget> screens = [
    const HomePage(),
    const FilePage(),
    const GroupsPage(),
    NotificationsScreen(),
    const SettingsPage(),
    const InfoSectionWidget()
  ];
  List<Widget> pages = [
    const HomePage(),
    const FilePage(),
    const GroupsPage(),
    NotificationsScreen(),
    const SettingsPage(),
    const InfoSectionWidget()
  ];

  updateUI() {
    update();
  }
}
