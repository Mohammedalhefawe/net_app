import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/home/controller/dashboard_controller.dart';
import 'package:web1/features/home/controller/group_controller.dart';
import 'package:web1/features/home/view/screens/files_in_group_screen.dart';
import 'package:web1/features/home/view/widgets/search_text_filed.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Get.find<DashboardController>();
    GroupController groupController = Get.put(GroupController());

    groupController.getAllGroups();

    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (groupController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              SearchTextField(
                  controller: TextEditingController(),
                  fileHandler: () {},
                  groupHandler: () {}),
              const SizedBox(height: 20),
              AddGroupWidget(
                addGroupFunction: () {
                  _showAddGroupDialog(context, groupController);
                },
              ),
              const SizedBox(height: 20),
              Text(
                'groups'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (groupController.groups.isEmpty)
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('no_groups'.tr),
                  ],
                ),
              if (groupController.groups.isNotEmpty)
                LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height - 200,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1 / 0.4,
                          crossAxisCount: constraints.maxWidth > 1000
                              ? 4
                              : constraints.maxWidth > 500
                                  ? 3
                                  : 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: groupController.groups.length,
                      itemBuilder: (context, index) {
                        final group = groupController.groups[index];

                        return InkWell(
                          onTap: () {
                            dashboardController.screens[2] =
                                FilesGroupPage(groupId: group.id.toString());
                            dashboardController.update();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(colors: [
                                Theme.of(context).cardColor.withOpacity(0.1),
                                Theme.of(context).cardColor.withOpacity(0.2),
                                Theme.of(context).cardColor.withOpacity(0.35),
                              ]),
                            ),
                            width: 200,
                            child: Center(
                              child: ListTile(
                                leading: SvgPicture.string(
                                  fileIcon,
                                  width: 40,
                                  height: 40,
                                  color: Theme.of(context).cardColor,
                                ),
                                title: Text(
                                  group.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${group.users.length} users in group',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showEditGroupDialog(
                                          context, groupController, group);
                                    } else if (value == 'delete') {
                                      _deleteGroup(groupController, group.id);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
            ],
          );
        }),
      ),
    );
  }

  void _showAddGroupDialog(
      BuildContext context, GroupController groupController) {
    final TextEditingController groupNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Group Name'),
          content: TextField(
            controller: groupNameController,
            decoration: const InputDecoration(
              labelText: 'Group Name',
              hintText: 'Enter the group name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Obx(() {
              return TextButton(
                onPressed: groupController.isLoading.value
                    ? null
                    : () async {
                        final groupName = groupNameController.text.trim();
                        if (groupName.isNotEmpty) {
                          await groupController.createGroup(groupName);
                          Navigator.of(context).pop();
                        } else {
                          Get.snackbar(
                            'Error',
                            'Group name cannot be empty!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                child: groupController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create'),
              );
            }),
          ],
        );
      },
    );
  }
}

class AddGroupWidget extends StatelessWidget {
  final void Function()? addGroupFunction;
  const AddGroupWidget({
    super.key,
    this.addGroupFunction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: addGroupFunction,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(colors: [
              Theme.of(context).cardColor.withOpacity(0.1),
              Theme.of(context).cardColor.withOpacity(0.13),
            ])),
        child: Center(
            child: Text(
          'add_group'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}

void _showEditGroupDialog(
    BuildContext context, GroupController groupController, dynamic group) {
  final TextEditingController groupNameController =
      TextEditingController(text: group.name);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Group Name'),
        content: TextField(
          controller: groupNameController,
          decoration: const InputDecoration(
            labelText: 'Group Name',
            hintText: 'Enter the new group name',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Obx(() {
            return TextButton(
              onPressed: groupController.isLoading.value
                  ? null
                  : () async {
                      final newName = groupNameController.text.trim();
                      if (newName.isNotEmpty) {
                        await groupController.editGroup(group.id, newName);
                        Navigator.of(context).pop();
                      } else {
                        Get.snackbar(
                          'Error',
                          'Group name cannot be empty!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
              child: groupController.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save'),
            );
          }),
        ],
      );
    },
  );
}

void _deleteGroup(GroupController groupController, int groupId) async {
  await groupController.deleteGroup(groupId);
}
