import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/home/view/widgets/search_text_filed.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SearchTextField(
                controller: TextEditingController(),
                fileHandler: () {},
                groupHandler: () {}),

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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SizedBox(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(end: 15),
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
            SizedBox(
              height: MediaQuery.sizeOf(context).height - 200,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 0),
                child: DataTable2(
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
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: Text('overview'.tr),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: Text('last_modified'.tr),
                        size: ColumnSize.L,
                      ),
                      const DataColumn2(
                        label: Text(''),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                        10,
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
                                  title: const Text('file name'),
                                ),
                              ),
                              const DataCell(Text('Group..')),
                              const DataCell(Text('2024/11/25')),
                              const DataCell(Text('2024/11/01')),
                              DataCell(
                                Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.string(
                                    listIcon,
                                    width: 20,
                                    height: 20,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                            ]))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
