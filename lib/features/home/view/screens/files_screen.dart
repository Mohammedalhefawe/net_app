import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/class/handlingdataview.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/home/controller/files_controller.dart';
import 'package:web1/features/home/data/model/archive_model.dart';
import 'package:web1/features/home/data/model/files_model.dart';
import 'package:web1/features/home/view/screens/files_in_group_screen.dart';
import 'package:web1/features/home/view/widgets/custom_drop_down.dart';
import 'package:web1/features/home/view/widgets/search_text_filed.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  Widget build(BuildContext context) {
    FilesController controller = Get.put(FilesController());
    return GetBuilder(
        init: controller,
        initState: (state) {
          controller.getFiles();
        },
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
                      addFileFunction: () async {
                        showAddDialog(context, controller);
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'my_upload_files'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class FilesTable extends StatelessWidget {
  final List<TableDataModle> data;
  final FilesController controller;
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
                            alignment: AlignmentDirectional.topStart,
                            fit: BoxFit.scaleDown,
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

class AddFileWidget extends StatelessWidget {
  final void Function()? addFileFunction;
  const AddFileWidget({
    super.key,
    this.addFileFunction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: addFileFunction,
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
          'add_file'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}

showAction(BuildContext context, FilesController controller, String type,
    {String? fileId, int? index}) async {
  if (type == 'checkin') {
    controller.downloadFiles(id: fileId);
  } else if (type == 'delete') {
    controller.deleteFiles(id: fileId);
  } else if (index != null && type == 'logs') {
    showLogDialog(context, controller.filesList[index].logs);
  } else if (index != null && type == 'report' && fileId != null) {
    controller.getReport(fileId, groupId: controller.filesList[index].groupId);
  } else if (type == 'archive' && index != null) {
    showArchiveDialog(context, controller.filesList[index].archives,
        groupId: controller.filesList[index].groupId);
  }
}

void showAddDialog(
  BuildContext context,
  FilesController controller,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add File'),
        content: GetBuilder(
            init: controller,
            builder: (controller) {
              return Form(
                key: controller.formstate,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomDropdownFormField(
                      validator: (value) {
                        if (controller.selectedGroup == null) {
                          return 'please select group';
                        }
                        return null;
                      },
                      items: controller.groupsList,
                      valueText: controller.selectedGroup?.title,
                      hintText: 'Select Section',
                      onChanged: (value) {
                        controller.onSelectGroup(value);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    FilePickerField(
                      controller: controller.isUploadingImage
                          ? TextEditingController(text: 'upladed file')
                          : null,
                      validator: (value) {
                        if (controller.pickedFile == null) {
                          return 'please select file';
                        }
                        return null;
                      },
                      hintText: 'Select file',
                      onTap: () {
                        controller.pickFile();
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              );
            }),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('cancel'.tr, style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(
            width: 15,
          ),
          TextButton(
            onPressed: () {
              controller.addFile();
            },
            child: Text('add'.tr),
          ),
        ],
      );
    },
  );
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

void showArchiveDialog(BuildContext context, List<ArchiveData> archives,
    {required String groupId}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('archive'.tr),
        content: GetBuilder(
            init: FilesController(),
            builder: (controller) {
              return SizedBox(
                width: 400,
                height: 300,
                child: HandlingDataRequest(
                  statusRequest: controller.statusRequest,
                  widget: archives.isEmpty
                      ? const Center(child: Text('No archive'))
                      : ListView.builder(
                          itemCount: archives.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Text("${'date'.tr} ${archives[index].date}"),
                                  const Spacer(),
                                  IconButton(
                                      tooltip: 'download'.tr,
                                      onPressed: () {
                                        controller.getArchiveFile(
                                            archives[index].id.toString(),
                                            groupId: groupId);
                                      },
                                      icon: const Icon(Icons.download)),
                                  IconButton(
                                      tooltip: 'compare'.tr,
                                      onPressed: () {
                                        controller.getCompareFile(
                                            archives[index].id.toString(),
                                            groupId: groupId);
                                      },
                                      icon: const Icon(Icons.compare)),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              );
            }),
      );
    },
  );
}
