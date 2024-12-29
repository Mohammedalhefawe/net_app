import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web1/class/crud.dart';
import 'package:web1/class/handingdatacontroller.dart';
import 'package:web1/class/statusrequest.dart';
import 'package:web1/features/home/data/data_source/files_data.dart';
import 'package:web1/features/home/data/model/notification_model.dart';

class NotificationsController extends GetxController {
  List<NotificationData> notificationsList = [];
  FilesData filesData = FilesData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;

  getNotification() async {
    notificationsList.clear();
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';
    statusRequest = StatusRequest.loading;
    update();
    var response = await filesData.getNotificationsData(token);

    ResponseJson responseJson = handlingData(response);
    statusRequest = responseJson.statusRequest;
    update();
    if (StatusRequest.success == statusRequest) {
      print(response);
      print('======================');
      update();
      NotificationsModel data = NotificationsModel.fromJson(response);
      if (data.data != null) {
        notificationsList = data.data!;
      }
    } else {
      print('error');
      Fluttertoast.showToast(msg: 'error');
    }
  }
}
