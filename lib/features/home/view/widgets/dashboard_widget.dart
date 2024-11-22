import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/constants/icons_svg.dart';

import '../screens/files_screen.dart';
import '../screens/groups_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import 'add_file_button_widget.dart';
import 'info_section_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _Dashboardscreenstate createState() => _Dashboardscreenstate();
}

class _Dashboardscreenstate extends State<DashboardScreen> {
  List<Widget> screens = [
    const HomePage(),
    const FilePage(),
    const GroupsPage(),
    const SettingsPage(),
  ];
  int _hoveredIndex = 0; // Track hovered row
  int _selectedScreenIndex = 0; // Track selected row

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Section
          Container(
            width: 250,
            color: Colors.blueGrey[900],
            child: ListView(
              children: [
                // Logo and Name
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      SvgPicture.string(
                        logoIcon,
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "file_management".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Add File Button
                AnimatedButtonDemo(
                  onPressed: () {},
                ),

                const SizedBox(
                  height: 30,
                ),
                // Navigation Rows
                _buildNavItem(homeIcon, "home".tr, 0),
                _buildNavItem(fileIcon, "files".tr, 1),
                _buildNavItem(groupIcon, "groups".tr, 2),
                _buildNavItem(settingIcon, "settings".tr, 3),
              ],
            ),
          ),

          // Right Section
          Expanded(
            child: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  screens[_selectedScreenIndex],
                  VerticalDivider(
                      width: 1,
                      color: Get.isDarkMode ? Colors.white24 : Colors.grey),
                  // Second Column
                  const InfoSectionWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String icon, String title, int index) {
    final bool isSelected = _selectedScreenIndex == index;
    final bool isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredIndex = index;
      }),
      onExit: (_) => setState(() {
        _hoveredIndex = -1;
      }),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedScreenIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Animation duration
          color: isSelected
              ? Colors.blueGrey[700]
              : isHovered
                  ? Colors.blueGrey[800]
                  : Colors.blueGrey[900],
          child: ListTile(
            leading: SvgPicture.string(
              icon,
              width: 20,
              height: 20,
              color: Colors.white,
            ),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
