import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:web1/constants/icons_svg.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function() fileHandler;
  final Function() groupHandler;
  const SearchTextField(
      {super.key,
      required this.controller,
      required this.fileHandler,
      required this.groupHandler});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'search'.tr,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.string(
            searchIcon,
            width: 16,
            height: 16,
            fit: BoxFit.scaleDown,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        suffixIcon: InkWell(
          onTap: () {
            showFilterDialog(context,
                fileHandler: fileHandler,
                groupHandler: groupHandler); // Call filter handler
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.string(
              filterIcon,
              width: 16,
              height: 16,
              fit: BoxFit.scaleDown,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
        filled: true, // Enables background color
        fillColor: Theme.of(context)
            .cardColor
            .withAlpha(30), // Sets the background color to a light gray
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Adds rounded corners
          borderSide: BorderSide.none, // Removes the default border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Adds rounded corners
          borderSide: BorderSide.none, // Removes the default border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Adds rounded corners
          borderSide: BorderSide.none, // Removes the default border
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ), // Adjusts padding
      ),
    );
  }
}

void showFilterDialog(BuildContext context,
    {required Function() groupHandler, required Function() fileHandler}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Filter Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: SvgPicture.string(
                groupIcon,
                width: 20,
                height: 20,
                color: Colors.blue,
              ),
              title: const Text('By Group'),
              onTap: () {
                Navigator.pop(context); // Close dialog
                groupHandler();
                print('Filter by Group selected');
              },
            ),
            ListTile(
              leading: SvgPicture.string(
                fileIcon,
                width: 20,
                height: 20,
                color: Colors.green,
              ),
              title: const Text('By File'),
              onTap: () {
                Navigator.pop(context); // Close dialog
                fileHandler();
                print('Filter by File selected');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

enum FilterType { group, file }
