import 'package:web1/class/crud.dart';
import '../class/statusrequest.dart';

ResponseJson handlingData(response) {
  if (response is ResponseJson) {
    return response;
  } else {
    return ResponseJson(statusRequest: StatusRequest.success, data: response);
  }
}
