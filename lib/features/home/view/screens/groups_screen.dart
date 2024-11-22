import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/home/view/widgets/search_text_filed.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

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
              'groups'.tr,
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
                    childAspectRatio: 1 / 0.4,
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: 10,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return AddGroupWidget(
                      onTap: () {},
                    );
                  }
                  return SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(colors: [
                            Theme.of(context).cardColor.withOpacity(0.1),
                            Theme.of(context).cardColor.withOpacity(0.2),
                            Theme.of(context).cardColor.withOpacity(0.35),
                          ])),
                      width: 200,
                      child: Center(
                        child: ListTile(
                          leading: SvgPicture.string(
                            fileIcon,
                            width: 40,
                            height: 40,
                            color: Theme.of(context).cardColor,
                          ),
                          title: const Text('Private'),
                          subtitle: Text(
                            'Group ${index + 1}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
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

class AddGroupWidget extends StatelessWidget {
  final void Function()? onTap;
  const AddGroupWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor.withOpacity(0.1),
          ),
          width: 200,
          child: Center(
            child: Text(
              'add_group'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
