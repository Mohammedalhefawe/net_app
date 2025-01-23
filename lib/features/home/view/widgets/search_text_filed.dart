import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:web1/constants/icons_svg.dart';

class SearchTextField extends StatelessWidget {
  final void Function(String)? onChanged;
  const SearchTextField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
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
        // suffixIcon: InkWell(
        //   onTap: () {
        //     showFilterDialog(context,
        //         fileHandler: fileHandler, groupHandler: groupHandler);
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.all(10),
        //     child: SvgPicture.string(
        //       filterIcon,
        //       width: 16,
        //       height: 16,
        //       fit: BoxFit.scaleDown,
        //       color: Theme.of(context).iconTheme.color,
        //     ),
        //   ),
        // ),
        filled: true,
        fillColor: Theme.of(context).cardColor.withAlpha(30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
      ),
    );
  }
}

// void showFilterDialog(BuildContext context,
//     {required Function() groupHandler, required Function() fileHandler}) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Filter Options'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: SvgPicture.string(
//                 groupIcon,
//                 width: 20,
//                 height: 20,
//                 color: Colors.blue,
//               ),
//               title: const Text('By Group'),
//               onTap: () {
//                 Navigator.pop(context);
//                 groupHandler();
//                 print('Filter by Group selected');
//               },
//             ),
//             ListTile(
//               leading: SvgPicture.string(
//                 fileIcon,
//                 width: 20,
//                 height: 20,
//                 color: Colors.green,
//               ),
//               title: const Text('By File'),
//               onTap: () {
//                 Navigator.pop(context);
//                 fileHandler();
//                 print('Filter by File selected');
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//         ],
//       );
//     },
//   );
// }

// enum FilterType { group, file }
