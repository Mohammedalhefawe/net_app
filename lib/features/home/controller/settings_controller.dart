import 'package:get/get.dart';
import 'package:web1/class/statusrequest.dart';
import 'package:web1/features/home/data/data_source/files_data.dart';

class SettingsController extends GetxController {
  FilesData filesData = FilesData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;

  @override
  onInit() async {
//
    super.onInit();
  }

  getReport(
    String id,
  ) async {
    // final pref = await SharedPreferences.getInstance();
    // final token = pref.getString('auth_token') ?? '';
    // statusRequest = StatusRequest.loading;
    // update();
    // var response = await filesData.getReportData(token, id, 'user',);
    // ResponseJson responseJson = handlingData(response);
    // statusRequest = responseJson.statusRequest;
    // update();
    // if (StatusRequest.success == statusRequest) {
    //   Fluttertoast.showToast(msg: 'sucess');
    // } else {
    //   Fluttertoast.showToast(msg: 'error');
    // }
  }
}
