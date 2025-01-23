import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/class/handlingdataview.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/auth/controller/auth_controller.dart';
import 'package:web1/features/auth/model/user_model.dart';
import 'package:web1/features/home/controller/file_controller.dart';
import 'package:web1/features/home/controller/group_controller.dart';
import 'package:web1/features/home/controller/groups_controller.dart';
import 'package:web1/features/home/data/model/archive_model.dart';
import 'package:web1/features/home/data/model/files_model.dart';
import 'package:web1/features/home/view/screens/files_screen.dart';
import 'package:web1/features/home/view/widgets/search_text_filed.dart';
import 'package:file_picker/file_picker.dart';

class FilesGroupPage extends StatefulWidget {
  final String groupId;

  const FilesGroupPage({super.key, required this.groupId});

  @override
  State<FilesGroupPage> createState() => _FilePageState();
}

class _FilePageState extends State<FilesGroupPage> {
  late String groupId;
  final FileController _fileController = Get.put(FileController());

  @override
  void initState() {
    super.initState();
    groupId = widget.groupId;
    print("Loaded files for Group ID: $groupId");
  }

  PlatformFile? selectedFile;

  void _showUsersDialog(BuildContext context) async {
    final AuthController authController = Get.find<AuthController>();
    bool isAdmin = false;

    try {
      final List<UserModel> users = await authController.getAllUsers();

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          UserModel? selectedUser;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Select a User".tr),
                content: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return ListTile(
                              title: Text(user.name ?? 'Unknown'),
                              subtitle: Text(user.id.toString()),
                              onTap: () {
                                setState(() {
                                  selectedUser = user;
                                });
                              },
                              selected: selectedUser == user,
                              selectedTileColor: Colors.blue.withOpacity(0.1),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: isAdmin,
                            onChanged: (value) {
                              setState(() {
                                isAdmin = value ?? false;
                              });
                            },
                          ),
                          const Text("Make Admin"),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedUser != null) {
                        final GroupController groupController =
                            Get.put(GroupController());
                        await groupController.addUserToGroup(
                          userId: selectedUser!.id!,
                          groupId: int.parse(widget.groupId),
                          isAdmin: isAdmin,
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select a user")),
                        );
                      }
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load users: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    GroupsController controller = Get.put(GroupsController());
    controller.groupId = widget.groupId;
    return GetBuilder(
        initState: (state) {
          controller.getFiles();
        },
        init: controller,
        builder: (controller) {
          return HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                height: MediaQuery.sizeOf(context).height,
                child: ListView(
                  children: [
                    SearchTextField(
                      onChanged: (value) {
                        controller.search(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    AddFileWidget(
                      addFileFunction: () {
                        _fileController.pickAndUploadFile(
                            groupId, true, controller);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'my_upload_files'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showGroupMembersDialog(
                                    controller.users, controller,
                                    groupId: controller.groupId);
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey[300],
                                child: const Icon(
                                  Icons.group,
                                  size: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showUsersDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor:
                                    Theme.of(context).cardColor.withAlpha(35),
                                elevation: 0,
                                backgroundColor:
                                    Theme.of(context).cardColor.withAlpha(30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                Icons.share,
                                size: 10,
                              ),
                              label: const Text("Shared Group"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //here
                    controller.getFilesCheck
                        ? FilesTable(
                            data: controller.filesList,
                            controller: controller,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

// void _showAllMembers(BuildContext context, String groupId) async {
//   final GroupController groupController = Get.find<GroupController>();
//   await groupController.getGroupDetails(groupId: int.parse(groupId));
// }

class TableDataModle {
  final String id;
  final String groupId;
  final String fileName;
  final String groupName;
  final String overView;
  final String lastEdit;
  final String state;
  List<FileLog> logs;
  List<ArchiveData> archives;
  bool check;

  TableDataModle(
      {required this.fileName,
      required this.id,
      required this.groupId,
      this.logs = const [],
      this.archives = const [],
      this.check = false,
      required this.groupName,
      required this.overView,
      required this.lastEdit,
      required this.state});
}

class FilesTable extends StatelessWidget {
  final List<TableDataModle> data;
  final GroupsController controller;
  const FilesTable({
    super.key,
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height - 200,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
      child: DataTable2(
          empty: Center(
            child: Text(
              'No Files Found',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black54),
            ),
          ),
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          border: TableBorder(
              horizontalInside: BorderSide(
                  color: Colors.black.withOpacity(0.01), width: 0.1)),
          columns: [
            DataColumn2(
              label: Text('select'.tr),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Text('file_name'.tr),
              ),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('group_name'.tr),
            ),
            // DataColumn2(
            //   label: Text('overview'.tr),
            // ),
            DataColumn2(
              label: Text('last_modified'.tr),
            ),
            DataColumn2(
              label: Text('status'.tr),
            ),
            DataColumn2(
              label: controller.checkFiles.isEmpty
                  ? Text('action'.tr)
                  : PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'checkin') {
                          showAction(
                            context,
                            controller,
                            'checkin',
                          );
                        } else if (value == 'delete') {
                          showAction(
                            context,
                            controller,
                            'delete',
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'checkin',
                          child: Text('checkin'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('delete'.tr),
                        ),
                      ],
                    ),
              size: ColumnSize.S,
            ),
          ],
          rows: List<DataRow>.generate(
              data.length,
              (index) => DataRow(cells: [
                    DataCell(data[index].state == 'closed'
                        ? const SizedBox()
                        : Checkbox(
                            value: data[index].check,
                            onChanged: (value) {
                              controller.checkFile(
                                  index, data[index].id, value ?? false);
                            })),
                    DataCell(
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: SvgPicture.string(
                          fileIcon,
                          width: 20,
                          height: 20,
                          color: Colors.blue,
                        ),
                        title: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              data[index].fileName.split('.').first,
                              style: const TextStyle(fontSize: 15),
                            )),
                      ),
                    ),
                    DataCell(Text(data[index].groupName)),
                    // DataCell(FittedBox(
                    //     fit: BoxFit.scaleDown,
                    //     child: Text(data[index].overView.split(' ')[0]))),
                    DataCell(FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(data[index].lastEdit.split(' ')[0]))),
                    DataCell(Text(data[index].state)),
                    DataCell(
                      controller.checkFiles.isNotEmpty
                          ? const Text('')
                          : PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'checkin') {
                                  showAction(context, controller, 'checkin',
                                      fileId: data[index].id, index: index);
                                } else if (value == 'checkout') {
                                  controller.pickFile(
                                      fileId: data[index].id,
                                      groupId: data[index].groupId);
                                } else if (value == 'delete') {
                                  showAction(context, controller, 'delete',
                                      fileId: data[index].id, index: index);
                                } else if (value == 'logs') {
                                  showAction(context, controller, 'logs',
                                      index: index);
                                } else if (value == 'report') {
                                  showAction(
                                    context,
                                    controller,
                                    'report',
                                    index: index,
                                    fileId: data[index].id,
                                  );
                                } else if (value == 'archive') {
                                  showAction(context, controller, 'archive',
                                      index: index);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                if (controller.filesList[index].state ==
                                    'closed')
                                  const PopupMenuItem<String>(
                                    value: 'checkout',
                                    child: Text('checkout'),
                                  ),
                                if (controller.filesList[index].state == 'open')
                                  const PopupMenuItem<String>(
                                    value: 'checkin',
                                    child: Text('checkin'),
                                  ),
                                if (controller.filesList[index].state == 'open')
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('delete'.tr),
                                  ),
                                PopupMenuItem<String>(
                                  value: 'logs',
                                  child: Text('logs'.tr),
                                ),
                                PopupMenuItem<String>(
                                  value: 'report',
                                  child: Text('report'.tr),
                                ),
                                PopupMenuItem<String>(
                                  value: 'archive',
                                  child: Text('archive'.tr),
                                ),
                              ],
                            ),
                    ),
                  ]))),
    );
  }
}

void showAction(BuildContext context, GroupsController controller, String type,
    {String? fileId, int? index}) {
  if (type == 'checkin') {
    controller.downloadFiles(id: fileId);
  } else if (type == 'delete') {
    controller.deleteFiles(id: fileId);
  } else if (index != null && type == 'logs') {
    showLogDialog(context, controller.filesList[index].logs);
  } else if (index != null && type == 'report' && fileId != null) {
    controller.getReport(fileId, groupId: controller.groupId);
  } else if (type == 'archive' && index != null) {
    showArchiveDialog(context, controller.filesList[index].archives,
        groupId: controller.filesList[index].groupId);
  }
}

void showLogDialog(
  BuildContext context,
  List<FileLog> logs,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('logs'.tr),
        content: SizedBox(
          width: 400,
          height: 300,
          child: logs.isEmpty
              ? const Center(child: Text('No logs'))
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${'date'.tr} ${logs[index].date}"),
                      subtitle: Text("action".tr + logs[index].operation),
                    );
                  },
                ),
        ),
      );
    },
  );
}

void showGroupMembersDialog(List<UserData> users, GroupsController controller,
    {required String groupId}) {
  Get.defaultDialog(
    title: "Group Members",
    content: SizedBox(
      width: 400,
      height: 300,
      child: ListView(
        children: users.map((user) {
          return Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[200],
                    child: Text(user.name[0].toUpperCase()),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                ),
              ),
              IconButton(
                  tooltip: 'download'.tr,
                  onPressed: () {
                    controller.getReportUser(user.id.toString(),
                        groupId: groupId);
                  },
                  icon: const Icon(Icons.download)),
            ],
          );
        }).toList(),
      ),
    ),
    confirm: ElevatedButton(
      onPressed: () {
        Get.back();
      },
      child: const Text("Close"),
    ),
  );
}
