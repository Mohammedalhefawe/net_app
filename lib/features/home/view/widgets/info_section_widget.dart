import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/constants/icons_svg.dart';

class InfoSectionWidget extends StatelessWidget {
  const InfoSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: CircleAvatar(
                child: SvgPicture.string(
                  userIcon,
                  width: 20,
                  height: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: const Text('John Doe'),
              subtitle: const Text(
                'johndoe@example.com',
                style: TextStyle(fontSize: 11),
              ),
            ),
            const SizedBox(height: 20),
            // Storage Info
            Text(
              'storage_info'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey[300],
              color: Theme.of(context).primaryColor,
              minHeight: 8,
            ),
            const SizedBox(height: 5),
            const Text('70% of 100GB used'),
            Column(
              children: [
                const SizedBox(height: 10),
                Divider(color: Colors.grey[300], thickness: 0.5),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsetsDirectional.only(start: 0),
                  leading: SvgPicture.string(
                    fileIcon,
                    width: 20,
                    height: 20,
                    color: Colors.amber,
                  ),
                  title: Text('files'.tr),
                  trailing: const Text('32 MB'),
                ),
                ListTile(
                  contentPadding: const EdgeInsetsDirectional.only(start: 0),
                  leading: SvgPicture.string(
                    imageIcon,
                    width: 20,
                    height: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('images'.tr),
                  trailing: const Text('32 MB'),
                ),
                ListTile(
                  contentPadding: const EdgeInsetsDirectional.only(start: 0),
                  leading: SvgPicture.string(
                    videoIcon,
                    width: 20,
                    height: 20,
                    color: Colors.blue,
                  ),
                  title: Text('videos'.tr),
                  trailing: const Text('32 MB'),
                ),
                ListTile(
                  contentPadding: const EdgeInsetsDirectional.only(start: 0),
                  leading: SvgPicture.string(
                    otherIcon,
                    width: 20,
                    height: 20,
                    color: Colors.red,
                  ),
                  title: Text('others'.tr),
                  trailing: const Text('32 MB'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
