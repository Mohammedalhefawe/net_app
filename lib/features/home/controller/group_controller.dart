import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web1/features/home/data/model/group_model.dart';
import 'package:web1/services/group_service.dart';

class GroupController extends GetxController {
  var isLoading = false.obs;
  var groups = <GroupModel>[].obs;

  Future<void> getAllGroups() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';

    if (token.isEmpty) {
      Fluttertoast.showToast(msg: 'Token not found!');
      return;
    }

    isLoading.value = true;
    try {
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      final response = await GroupService().getAllGroups(token);
      print(response);
      print(';;;;;;;');

      if (response != null && response['message'] == 'Success') {
        List<GroupModel> fetchedGroups = (response['data'] as List)
            .map((groupData) => GroupModel.fromJson(groupData))
            .toList();
        groups.value = fetchedGroups;
      } else {
        Fluttertoast.showToast(msg: 'Failed to load groups');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  search(String value) async {
    if (value.isNotEmpty) {
      groups.value = groups
          .where((element) => element.name.toLowerCase().contains(value))
          .toList();
    } else {
      await getAllGroups();
    }
  }

  Future<void> createGroup(String groupName) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';

    if (token.isEmpty) {
      Fluttertoast.showToast(msg: 'Token not found!');
      return;
    }

    isLoading.value = true;
    try {
      final response = await GroupService().createGroup(groupName, token);

      if (response != null && response['message'] == 'success') {
        Fluttertoast.showToast(msg: 'Group created successfully');

        GroupModel newGroup = GroupModel.fromJson(response['data']);
        groups.add(newGroup);
      } else {
        Fluttertoast.showToast(msg: 'Failed to create group');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUserToGroup(
      {required int userId,
      required int groupId,
      required bool isAdmin}) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';

    if (token.isEmpty) {
      Fluttertoast.showToast(msg: 'Token not found!');
      return;
    }

    isLoading.value = true;
    try {
      final response = await GroupService().createUserGroup(
        userId: userId,
        groupId: groupId,
        isAdmin: isAdmin,
        token: token,
      );

      if (response != null && response['message'] == 'success') {
        Fluttertoast.showToast(msg: 'User added to group successfully!');
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to add user to group', timeInSecForIosWeb: 3);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e", timeInSecForIosWeb: 3);
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> getGroupDetails({required int groupId}) async {
  //   final pref = await SharedPreferences.getInstance();
  //   final token = pref.getString('auth_token') ?? '';

  //   if (token.isEmpty) {
  //     Fluttertoast.showToast(msg: 'Token not found!');
  //     return;
  //   }

  //   isLoading.value = true;
  //   try {
  //     final response =
  //         await GroupService().getGroupDetails(groupId: groupId, token: token);

  //     if (response != null && response['message'] == 'success') {
  //       final groupData = response['data'];
  //       final groupUsers = groupData['users'] as List;
  //       List<UserModel> users =
  //           groupUsers.map((user) => UserModel.fromJson(user)).toList();

  //       _showGroupMembersDialog(users);
  //     } else {
  //       Fluttertoast.showToast(msg: 'Failed to load group details');
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "Error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> editGroup(int groupId, String newName) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';

    if (token.isEmpty) {
      Fluttertoast.showToast(msg: 'Token not found!');
      return;
    }

    isLoading.value = true;
    try {
      final response = await GroupService()
          .editGroup(groupId: groupId, newName: newName, token: token);

      if (response != null && response['message'] == 'success') {
        final groupIndex = groups.indexWhere((group) => group.id == groupId);
        if (groupIndex != -1) {
          groups[groupIndex].name = newName;
          groups.refresh();
        }
        Fluttertoast.showToast(msg: 'Group updated successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to update group');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteGroup(int groupId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';

    if (token.isEmpty) {
      Fluttertoast.showToast(msg: 'Token not found!');
      return;
    }

    isLoading.value = true;
    try {
      final response =
          await GroupService().deleteGroup(groupId: groupId, token: token);

      if (response != null && response['message'] == 'success') {
        groups.removeWhere((group) => group.id == groupId);
        Fluttertoast.showToast(msg: 'Group deleted successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to delete group');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
