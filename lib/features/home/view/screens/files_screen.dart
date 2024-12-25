import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/home/view/widgets/search_text_filed.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  PlatformFile? selectedFile;

  Future<void> pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf', 'doc', 'docx'],
        type: FileType.custom,
        allowMultiple: false, 
        withData: true, 
      );

      if (result != null) {
        setState(() {
          selectedFile = result.files.first; 
        });
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: MediaQuery.sizeOf(context).height,
        child: ListView(
          children: [
            SearchTextField(
                controller: TextEditingController(),
                fileHandler: () {},
                groupHandler: () {}),

            const SizedBox(height: 20),
            AddFileWidget(
              addFileFunction: () async {
                await pickAndUploadFile();
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
            FilesTable(
              data: [
                TableDataModle(
                  fileName: 'file_name',
                  groupName: 'group_name',
                  overView: 'overview',
                  lastEdit: 'last_edit',
                  state: 'status',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilesTable extends StatefulWidget {
  final List<TableDataModle> data;
  const FilesTable({
    super.key,
    required this.data,
  });

  @override
  State<FilesTable> createState() => _FilesTableState();
}

class _FilesTableState extends State<FilesTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height - 200,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
      child: DataTable2(
          empty: const Center(
            child: Text(
              'No Files Found',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
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
            DataColumn2(
              label: Text('overview'.tr),
            ),
            DataColumn2(
              label: Text('last_modified'.tr),
            ),
            DataColumn2(
              label: Text('status'.tr),
            ),
            DataColumn2(
              label: selectedCount == 0
                  ? Text('action'.tr)
                  : Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          showActionDialog(context);
                        },
                        child: SvgPicture.string(
                          listIcon,
                          width: 20,
                          height: 20,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
              size: ColumnSize.S,
            ),
          ],
          rows: List<DataRow>.generate(
              widget.data.length,
              (index) => DataRow(cells: [
                    DataCell(Checkbox(
                        value: selectedRows[index] ?? false,
                        onChanged: (value) {
                          setState(() {
                            selectedCount += value! ? 1 : -1;
                            selectedRows[index] = value;
                          });
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
                        title: const Text('file name'),
                      ),
                    ),
                    const DataCell(Text('Group..')),
                    const DataCell(Text('2024/11/25')),
                    const DataCell(Text('2024/11/01')),
                    const DataCell(Text('Check In')),
                    DataCell(
                      selectedCount != 0
                          ? const Text('')
                          : Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  showActionDialog(context);
                                },
                                child: SvgPicture.string(
                                  listIcon,
                                  width: 20,
                                  height: 20,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
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

class TableDataModle {
  final String fileName;
  final String groupName;
  final String overView;
  final String lastEdit;
  final String state;
  final bool check;

  TableDataModle(
      {required this.fileName,
      this.check = false,
      required this.groupName,
      required this.overView,
      required this.lastEdit,
      required this.state});
}

Map<int, bool> selectedRows = {};
int selectedCount = 0;

void showActionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Select Action"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share, color: Colors.blue),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _performAction(context, "Share");
              },
            ),
            ListTile(
              leading: const Icon(Icons.check, color: Colors.green),
              title: const Text('Check-In'),
              onTap: () {
                Navigator.pop(context);
                _performAction(context, "Check-In");
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _performAction(context, "Delete");
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                _performAction(context, "Rename");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}

void _performAction(BuildContext context, String action) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$action selected')),
  );
}
