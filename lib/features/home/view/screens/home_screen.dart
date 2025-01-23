import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/class/handlingdataview.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/home/controller/dashboard_controller.dart';
import 'package:web1/features/home/controller/home_controller.dart';
import 'package:web1/features/home/data/model/files_model.dart';
import 'package:web1/features/home/view/screens/files_in_group_screen.dart';
import 'package:web1/features/home/view/screens/files_screen.dart';
import 'package:web1/features/home/view/widgets/search_text_filed.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    DashboardController dashboardController = Get.find<DashboardController>();
    return GetBuilder(
        initState: (state) {
          controller.getGroups();
          controller.getFiles();
        },
        init: controller,
        builder: (controller) {
          return HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    SearchTextField(
                      onChanged: (value) {
                        controller.search(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'recently_groups_used'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      child: controller.groupsList.isEmpty
                          ? Center(
                              child: Text(
                                'No groups',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black54),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.groupsList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    dashboardController.selectedScreenIndex = 2;
                                    dashboardController.screens[2] =
                                        FilesGroupPage(
                                            groupId: controller
                                                .groupsList[index].id
                                                .toString());
                                    dashboardController.update();
                                  },
                                  child: SizedBox(
                                    child: Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          end: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          gradient: LinearGradient(colors: [
                                            Theme.of(context)
                                                .cardColor
                                                .withOpacity(0.1),
                                            Theme.of(context)
                                                .cardColor
                                                .withOpacity(0.2),
                                            Theme.of(context)
                                                .cardColor
                                                .withOpacity(0.35),
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
                                          title: Text(controller
                                              .groupsList[index].title),
                                          subtitle: Text(
                                            '${controller.groupsList[index].subTitle}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'recently_files_used'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

class FilesTable extends StatelessWidget {
  final List<TableDataModle> data;
  final HomeController controller;
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
              label: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Text('file_name'.tr),
              ),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('group_name'.tr),
            ),
            DataColumn2(
              label: Text('overview'.tr),
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

void showAction(BuildContext context, HomeController controller, String type,
    {String? fileId, int? index}) {
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
