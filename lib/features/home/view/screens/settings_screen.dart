import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/auth/controller/app_controller.dart';
import 'package:web1/features/home/view/widgets/search_text_filed.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Search TextField
            SearchTextField(
                controller: TextEditingController(),
                fileHandler: () {},
                groupHandler: () {}),
            const SizedBox(height: 20),
            // Recently Files Used
            Text(
              'settings'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.sizeOf(context).height - 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 0.2,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: settings.length,
                itemBuilder: (context, index) {
                  return SettingItemWidget(
                    title: settings[index].tilte.tr,
                    icon: settings[index].icon,
                    onTap: () {
                      if (settings[index].tilte.tr == 'language'.tr) {
                        showLanguageDialog(context);

                        print('Language selected');
                      } else if (settings[index].tilte.tr == 'theme'.tr) {
                        showThemeDialog(context);
                        print('Theme selected');
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItemWidget extends StatelessWidget {
  final void Function()? onTap;
  final String icon;
  final String title;
  const SettingItemWidget(
      {super.key, this.onTap, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor.withOpacity(0.1),
          ),
          width: 200,
          child: Row(
            children: [
              SvgPicture.string(
                icon,
                width: 25,
                height: 25,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10),
              Text(
                title,
              ),
              const Spacer(),
              RotatedBox(
                quarterTurns: Get.locale?.languageCode == 'ar' ? 2 : 0,
                child: SvgPicture.string(
                  arrowIcon,
                  width: 25,
                  height: 25,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem {
  final String tilte;
  final String icon;
  SettingItem({required this.tilte, required this.icon});
}

List<SettingItem> settings = [
  SettingItem(tilte: "language", icon: languageIcon),
  SettingItem(tilte: "theme", icon: themeIcon),
  SettingItem(tilte: "help", icon: helpIcon),
  SettingItem(tilte: "about", icon: aboutIcon),
  SettingItem(tilte: "logout", icon: logoutIcon),
];

void showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('select_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: SvgPicture.string(
                languageIcon,
                width: 25,
                height: 25,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text('english'.tr),
              onTap: () {
                Navigator.pop(context); // Close dialog
                AppController().changeLocale(
                  const Locale('en', 'US'),
                );
                settings = settings;
              },
            ),
            ListTile(
              leading: SvgPicture.string(
                languageIcon,
                width: 25,
                height: 25,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text('arabic'.tr),
              onTap: () {
                Navigator.pop(context); // Close dialog
                AppController().changeLocale(const Locale('ar', 'AE'));
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text('cancel'.tr),
          ),
        ],
      );
    },
  );
}

void showThemeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('select_theme'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: SvgPicture.string(
                darkThemeIcon,
                width: 25,
                height: 25,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text('dark'.tr),
              onTap: () {
                Navigator.pop(context); // Close dialog
                if (!Get.isDarkMode) {
                  Get.changeThemeMode(ThemeMode.dark);
                }
              },
            ),
            ListTile(
              leading: SvgPicture.string(
                themeIcon,
                width: 25,
                height: 25,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text('light'.tr),
              onTap: () {
                Navigator.pop(context); // Close dialog
                if (Get.isDarkMode) {
                  Get.changeThemeMode(ThemeMode.light);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text('cancel'.tr),
          ),
        ],
      );
    },
  );
}
