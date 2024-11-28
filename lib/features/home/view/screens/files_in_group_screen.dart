import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/features/home/view/screens/files_screen.dart';
import 'package:web1/features/home/view/widgets/search_text_filed.dart';
import 'package:file_picker/file_picker.dart';

class FilesGroupPage extends StatefulWidget {
  const FilesGroupPage({super.key});

  @override
  State<FilesGroupPage> createState() => _FilePageState();
}

class _FilePageState extends State<FilesGroupPage> {
  final List<String> groupMembers = ["Alice", "Bob", "Charlie", "Diana"];

  PlatformFile? selectedFile;

  Future<void> pickAndUploadFile() async {
    try {
      // Step 1: Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf', 'doc', 'docx'],
        type: FileType.custom,
        allowMultiple: false, // Set to false for single file selection
        withData: true, // Ensures the bytes are loaded into memory (web)
      );

      if (result != null) {
        setState(() {
          selectedFile = result.files.first; // Get the first selected file
        });

        // Step 2: Upload the file to server
        // await uploadFile(selectedFile!);
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  // Function to show all members
  void _showAllMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("All Group Members"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: groupMembers
                .map((member) => ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue[200],
                        child: Text(
                          member[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(member),
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // Function to handle inviting a new member
  void _inviteNewMember(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invite new member action triggered!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: MediaQuery.sizeOf(context).height,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search TextField
            SearchTextField(
                controller: TextEditingController(),
                fileHandler: () {},
                groupHandler: () {}),

            const SizedBox(height: 20),
            // Recently Groups Used
            AddFileWidget(
              addFileFunction: () {
                pickAndUploadFile();
              },
            ),
            const SizedBox(height: 20),
            // Recently Files Used
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
                    ...groupMembers.take(3).map((member) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blue[200],
                          child: Text(
                            member[0], // First character of the name
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),

                    // See all members circle
                    GestureDetector(
                      onTap: () {
                        _showAllMembersDialog(context);
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

                    // Invite new members button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle invite new member action
                        _inviteNewMember(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shadowColor:
                              Theme.of(context).cardColor.withAlpha(35),
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).cardColor.withAlpha(30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
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
  // final void Function(bool?)? onChanged;
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
                      child: SvgPicture.string(
                        listIcon,
                        width: 20,
                        height: 20,
                        color: Theme.of(context).iconTheme.color,
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
                              child: SvgPicture.string(
                                listIcon,
                                width: 20,
                                height: 20,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                    ),
                  ]))),
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
