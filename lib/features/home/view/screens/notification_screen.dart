import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web1/class/handlingdataview.dart';
import 'package:web1/features/home/controller/notifications_controller.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationsController controller = Get.put(NotificationsController());
    return GetBuilder(
        initState: (state) {
          controller.getNotification();
        },
        init: controller,
        builder: (controller) {
          return HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: controller.notificationsList.isEmpty
                      ? Center(
                          child: Text(
                          'No notifications available.'.tr,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black54),
                        ))
                      : ListView.builder(
                          itemCount: controller.notificationsList.length,
                          itemBuilder: (context, index) {
                            final notification =
                                controller.notificationsList[index];
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: const Icon(Icons.notifications,
                                    color: Colors.blue),
                                title: Text(notification.content),
                                subtitle: Text(
                                  'Created in  ${timeWithFormate(notification.createdAt)}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                )),
          );
        });
  }
}

timeWithFormate(timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);

  // Extracting the date
  String date = DateFormat('yyyy-MM-dd').format(dateTime);

  // Extracting the time
  String time = DateFormat('HH:mm').format(dateTime);

  return 'Date => $date Time => $time';
}
