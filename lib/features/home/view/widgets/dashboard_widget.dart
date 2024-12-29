import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/home/controller/dashboard_controller.dart';
import 'package:web1/features/home/controller/files_controller.dart';
import 'package:web1/features/home/view/screens/files_screen.dart';
import 'add_file_button_widget.dart';
import 'info_section_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: constraints.maxWidth > 600
            ? null
            : AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.string(
                    logoIcon,
                    width: 16,
                    height: 16,
                  ),
                ),
                title: Text(
                  "file_management".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      showScreenSelectorDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.string(
                        listIcon,
                        color: Colors.white,
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
        body: GetBuilder<DashboardController>(
          init: controller,
          builder: (cotroller) {
            return Builder(builder: (context) {
              return Row(
                children: [
                  if (constraints.maxWidth > 600)
                    Container(
                      width: constraints.maxWidth > 1000
                          ? constraints.maxWidth / 5
                          : 230,
                      color: Colors.blueGrey[900],
                      child: ListView(
                        children: [
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
                          GetBuilder(
                              init: FilesController(),
                              builder: (controller) {
                                return AnimatedButtonDemo(
                                  onPressed: () {
                                    showAddDialog(context, controller);
                                  },
                                );
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                          buildNavItem(homeIcon, "home".tr, 0, false),
                          buildNavItem(fileIcon, "files".tr, 1, false),
                          buildNavItem(groupIcon, "groups".tr, 2, false),
                          buildNavItem(
                              notificationIcon, "notifications".tr, 3, false),
                          buildNavItem(settingIcon, "settings".tr, 4, false),
                          constraints.maxWidth <= 1200
                              ? buildNavItem(
                                  settingIcon, "storage info".tr, 4, false)
                              : const SizedBox()
                        ],
                      ),
                    ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 2,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: constraints.maxWidth > 1200
                          ? Row(
                              children: [
                                controller
                                    .screens[controller.selectedScreenIndex],
                                VerticalDivider(
                                    width: 1,
                                    color: Get.isDarkMode
                                        ? Colors.white24
                                        : Colors.grey),
                                const InfoSectionWidget(),
                              ],
                            )
                          : controller.screens[controller.selectedScreenIndex],
                    ),
                  ),
                ],
              );
            });
          },
        ),
      );
    });
  }
}

Widget buildNavItem(String icon, String title, int index, bool isPop) {
  DashboardController controller = Get.find<DashboardController>();

  final bool isSelected = controller.selectedScreenIndex == index;
  final bool isHovered = controller.hoveredIndex == index;

  return MouseRegion(
    onEnter: (_) {
      controller.hoveredIndex = index;
      controller.updateUI();
    },
    onExit: (_) {
      controller.hoveredIndex = -1;
      controller.updateUI();
    },
    child: GestureDetector(
      onTap: () {
        controller.selectedScreenIndex = index;
        controller.updateUI();
        controller.screens = List.from(controller.pages);
        if (isPop) {
          Get.back();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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

void showScreenSelectorDialog(BuildContext context) {
  final alignment =
      Get.locale!.languageCode == 'en' ? Alignment.topRight : Alignment.topLeft;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildNavItem(homeIcon, "home".tr, 0, true),
                  buildNavItem(fileIcon, "files".tr, 1, true),
                  buildNavItem(groupIcon, "groups".tr, 2, true),
                  buildNavItem(notificationIcon, "notifications".tr, 3, true),
                  buildNavItem(settingIcon, "settings".tr, 4, true),
                  buildNavItem(settingIcon, "storage info".tr, 5, true)
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
